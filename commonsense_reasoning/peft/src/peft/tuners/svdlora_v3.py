import importlib
import math
import re
import warnings
from dataclasses import asdict, dataclass, field
from enum import Enum
from typing import List, Optional, Union

import torch
import torch.nn as nn
import torch.nn.functional as F
from transformers.pytorch_utils import Conv1D

from ..utils import PeftConfig, PeftType, transpose


def is_bnb_available():
    return importlib.util.find_spec("bitsandbytes") is not None


if is_bnb_available():
    import bitsandbytes as bnb


@dataclass
class SVDLora_v3_Config(PeftConfig):
    """
    lue
    """

    r: int = field(default=8, metadata={"help": "Lora attention dimension"})
    target_modules: Optional[Union[List[str], str]] = field(
        default=None,
        metadata={
            "help": "List of module names or regex expression of the module names to replace with Lora."
            "For example, ['q', 'v'] or '.*decoder.*(SelfAttention|EncDecAttention).*(q|v)$' "
        },
    )
    lora_alpha: int = field(default=None, metadata={"help": "Lora alpha"})
    lora_dropout: float = field(default=None, metadata={"help": "Lora dropout"})
    merge_weights: bool = field(
        default=False, metadata={"help": "Merge weights of the original model and the Lora model"}
    )
    fan_in_fan_out: bool = field(
        default=False,
        metadata={"help": "Set this to True if the layer to replace stores weight like (fan_in, fan_out)"},
    )
    # -------------------------
    # some special params?
    # -------------------------
    enable_lora: Optional[List[bool]] = field(default=None, metadata={"help": "Used with `lora.MergedLinear`."})
    bias: str = field(default="none", metadata={"help": "Bias type for Lora. Can be 'none', 'all' or 'lora_only'"})
    modules_to_save: Optional[List[str]] = field(
        default=None,
        metadata={
            "help": "List of modules apart from LoRA layers to be set as trainable and saved in the final checkpoint. "
            "For example, in Sequence Classification or Token Classification tasks, "
            "the final layer `classifier/score` are randomly initialized and as such need to be trainable and saved."
        },
    )

    def __post_init__(self):
        self.peft_type = PeftType.SVDLORA_v3


class SVDLora_v3_Model(torch.nn.Module):
    """
    lue
    """
    def __init__(self, config, model):
        super().__init__()
        self.peft_config = config
        self.model = model
        self._find_and_replace()
        mark_only_lora_as_trainable(self.model, self.peft_config.bias)
        self.forward = self.model.forward

    def _find_and_replace(self):
        loaded_in_8bit = getattr(self.model, "is_loaded_in_8bit", False)
        if loaded_in_8bit and not is_bnb_available():
            raise ImportError(
                "To use Lora with 8-bit quantization, please install the `bitsandbytes` package. "
                "You can install it with `pip install bitsandbytes`."
            )
        is_target_modules_in_base_model = False
        is_hf_device_map_available = hasattr(self.model, "hf_device_map")
        kwargs = {
            "r": self.peft_config.r,
            "lora_alpha": self.peft_config.lora_alpha,
            "lora_dropout": self.peft_config.lora_dropout,
            "fan_in_fan_out": self.peft_config.fan_in_fan_out,
            "merge_weights": (self.peft_config.merge_weights or self.peft_config.inference_mode)
            and not is_hf_device_map_available,
            # "dora_simple": self.peft_config.dora_simple
        }
        key_list = [key for key, _ in self.model.named_modules()]
        for key in key_list:
            if isinstance(self.peft_config.target_modules, str):
                target_module_found = re.fullmatch(self.peft_config.target_modules, key)
            else:
                target_module_found = any(key.endswith(target_key) for target_key in self.peft_config.target_modules)
            if target_module_found:
                if not is_target_modules_in_base_model:
                    is_target_modules_in_base_model = True
                parent, target, target_name = self._get_submodules(key)
                bias = target.bias is not None
                if loaded_in_8bit and isinstance(target, bnb.nn.Linear8bitLt):
                    kwargs.update(
                        {
                            "has_fp16_weights": target.state.has_fp16_weights,
                            "memory_efficient_backward": target.state.memory_efficient_backward,
                            "threshold": target.state.threshold,
                            "index": target.index,
                        }
                    )
                    if self.peft_config.enable_lora is None:
                        print("8 bit lora")
                        new_module = Linear8bitLt(target.in_features, target.out_features, bias=bias, **kwargs)
                    else:
                        kwargs.update({"enable_lora": self.peft_config.enable_lora})
                        new_module = MergedLinear8bitLt(target.in_features, target.out_features, bias=bias, **kwargs)
                elif isinstance(target, torch.nn.Linear) and self.peft_config.enable_lora is None:
                    new_module = Linear(target.in_features, target.out_features, bias=bias, **kwargs)
                elif self.peft_config.enable_lora is not None:
                    kwargs.update({"enable_lora": self.peft_config.enable_lora})
                    if isinstance(target, Conv1D):
                        in_features, out_features = (
                            target.weight.ds_shape if hasattr(target.weight, "ds_shape") else target.weight.shape
                        )
                    else:
                        in_features, out_features = target.in_features, target.out_features
                        if kwargs["fan_in_fan_out"]:
                            warnings.warn(
                                "fan_in_fan_out is set to True but the target module is not a Conv1D. "
                                "Setting fan_in_fan_out to False."
                            )
                            kwargs["fan_in_fan_out"] = self.peft_config.fan_in_fan_out = False
                    new_module = MergedLinear(in_features, out_features, bias=bias, **kwargs)
                self._replace_module(parent, target_name, new_module, target)
                print(key, "finished(Model type: SVDLora_v3_Model)")
        if not is_target_modules_in_base_model:
            raise ValueError(
                f"Target modules {self.peft_config.target_modules} not found in the base model. "
                f"Please check the target modules and try again."
            )
        
    def _get_submodules(self, key):
        parent = self.model.get_submodule(".".join(key.split(".")[:-1]))
        target_name = key.split(".")[-1]
        target = self.model.get_submodule(key)
        return parent, target, target_name

    def _replace_module(self, parent_module, child_name, new_module, old_module):
        setattr(parent_module, child_name, new_module)
        new_module.weight = old_module.weight

        with torch.no_grad():
            u, s, v = torch.linalg.svd(new_module.weight.detach().to(dtype=torch.float32), full_matrices=False)
            new_module.lora_sigma.weight.copy_(s.unsqueeze(1).detach())
            new_module.svd_u.weight.copy_(u.detach())
            new_module.svd_v.weight.copy_(v.detach())
        # self.svd_v.weight.data.copy_(v.detach())
        del u, s, v
        # torch.cuda.empty_cache()

        if old_module.bias is not None:
            new_module.bias = old_module.bias
        if getattr(old_module, "state", None) is not None:
            new_module.state = old_module.state
            new_module.to(old_module.weight.device)

        # dispatch to correct device
        for name, module in new_module.named_modules():
            if "lora_" in name:
                module.to(old_module.weight.device)

    def __getattr__(self, name: str):
        """Forward missing attributes to the wrapped module."""
        try:
            return super().__getattr__(name)  # defer to nn.Module's logic
        except AttributeError:
            return getattr(self.model, name)

    @property
    def modules_to_save(self):
        return None

    def get_peft_config_as_dict(self, inference: bool = False):
        config = {k: v.value if isinstance(v, Enum) else v for k, v in asdict(self.peft_config).items()}
        if inference:
            config["inference_mode"] = True
        return config

    def _set_adapter_layers(self, enabled=True):
        for module in self.model.modules():
            if isinstance(module, LoraLayer):
                module.disable_adapters = False if enabled else True

    def enable_adapter_layers(self):
        self._set_adapter_layers(enabled=True)

    def disable_adapter_layers(self):
        self._set_adapter_layers(enabled=False) 


# had to adapt it for `lora_only` to work
def mark_only_lora_as_trainable(model: nn.Module, bias: str = "none") -> None:
    for n, p in model.named_parameters():
        if "lora_" not in n:
            p.requires_grad = False
    if bias == "none":
        return
    elif bias == "all":
        for n, p in model.named_parameters():
            if "bias" in n:
                p.requires_grad = True
    elif bias == "lora_only":
        for m in model.modules():
            if isinstance(m, LoraLayer) and hasattr(m, "bias") and m.bias is not None:
                m.bias.requires_grad = True
    else:
        raise NotImplementedError   


class LoraLayer:
    def __init__(
        self,
        r: int,
        lora_alpha: int,
        lora_dropout: float,
        merge_weights: bool,
    ):
        self.r = r
        self.lora_alpha = lora_alpha
        # Optional dropout
        if lora_dropout > 0.0:
            self.lora_dropout = nn.Dropout(p=lora_dropout)
        else:
            self.lora_dropout = lambda x: x
        # Mark the weight as unmerged
        self.merged = False
        self.merge_weights = merge_weights
        self.disable_adapters = False


class Linear(nn.Linear, LoraLayer):
    def __init__(
        self,
        in_features: int,
        out_features: int,
        r: int = 0,
        lora_alpha: int = 1,
        lora_dropout: float = 0.0,
        fan_in_fan_out: bool = False,  # Set this to True if the layer to replace stores weight like (fan_in, fan_out)
        merge_weights: bool = True,
        **kwargs,
    ):
        nn.Linear.__init__(self, in_features, out_features, **kwargs)
        LoraLayer.__init__(self, r=r, lora_alpha=lora_alpha, lora_dropout=lora_dropout, merge_weights=merge_weights)

        self.fan_in_fan_out = fan_in_fan_out
        # Actual trainable parameters
        if r > 0:
            k = min(in_features, out_features)
            self.svd_u = nn.Linear(k, out_features, bias=False)
            self.svd_v = nn.Linear(in_features, k, bias=False)
            self.lora_sigma = nn.Linear(1, k, bias=False)

            self.lora_A_1 = nn.Linear(in_features, r, bias=False)
            self.lora_B_1 = nn.Linear(r, k, bias=False)
            self.lora_A_2 = nn.Linear(k, r, bias=False)
            self.lora_B_2 = nn.Linear(r, out_features, bias=False)
            
            self.scaling = self.lora_alpha / self.r
            self.weight.requires_grad = False
        self.reset_parameters()
        if fan_in_fan_out:
            self.weight.data = self.weight.data.T

    def reset_parameters(self):
        nn.Linear.reset_parameters(self)
        if hasattr(self, "lora_A_1"):
            nn.init.kaiming_uniform_(self.lora_A_1.weight, a=math.sqrt(5))
            nn.init.kaiming_uniform_(self.lora_A_2.weight, a=math.sqrt(5))
            nn.init.zeros_(self.lora_B_1.weight)
            nn.init.zeros_(self.lora_B_2.weight)

    def train(self, mode: bool=True):
        nn.Linear.train(self, mode)
        self.lora_A_1.train(mode)
        self.lora_B_1.train(mode)
        self.lora_A_2.train(mode)
        self.lora_B_2.train(mode)
        self.lora_sigma.train(mode)

        if not mode and self.merge_weights and not self.merged:
            # Merge the weights and mark it
            # if self.r > 0:
            new_weight_u = self.svd_u.weight + transpose(self.lora_B_1.weight @ self.lora_A_1.weight, fan_in_fan_out=self.fan_in_fan_out) * self.scaling
            new_weight_v = self.svd_v.weight + transpose(self.lora_B_2.weight @ self.lora_A_2.weight, fan_in_fan_out=self.fan_in_fan_out) * self.scaling
            self.weight.data.copy_(new_weight_u * self.lora_sigma.weight.view(-1) @ new_weight_v)
            self.merged = True
            print("Merged!")
        elif self.merge_weights and self.merged:
            # Make sure that the weights are not merged
            # if self.r > 0:
            # self.weight.data -= (
            #     transpose(self.lora_B.weight @ self.lora_sigma.weight @ self.lora_A.weight, fan_in_fan_out=self.fan_in_fan_out) * self.scaling
            # )
            # self.weight.data += self.weight_low
            self.merged = True

    def eval(self):
        nn.Linear.eval(self)
        self.lora_A_1.eval()
        self.lora_A_2.eval()
        self.lora_sigma.eval()
        self.lora_B_1.eval()    
        self.lora_B_2.eval()

    def forward(self, x: torch.Tensor):
        previous_dtype = self.weight.dtype

        if self.disable_adapters:
            raise NotImplementedError
        
        elif self.r > 0 and not self.merged:
            temp_result = F.linear(x.to(self.svd_v.weight.dtype), transpose(self.svd_v.weight, self.fan_in_fan_out), bias=self.bias)
            temp_result += ((self.lora_dropout(x.to(self.lora_A_1.weight.dtype)) @ self.lora_A_1.weight.T) @ self.lora_B_1.weight.T) * self.scaling
            temp_result = temp_result * self.lora_sigma.weight.view(-1)
            result = F.linear(temp_result, transpose(self.svd_u.weight, self.fan_in_fan_out), bias=self.bias)
            result += ((self.lora_dropout(temp_result.to(self.lora_A_2.weight.dtype)) @ self.lora_A_2.weight.T) @ self.lora_B_2.weight.T) * self.scaling

            # result = F.linear(x.to(self.svd_v.weight.dtype), transpose(self.svd_v.weight, fan_in_fan_out=self.fan_in_fan_out), bias=self.bias)
            # result += ((self.lora_dropout(x.to(self.lora_A_1.weight.dtype)) @ self.lora_A_1.weight.T) @ self.lora_B_1.weight.T) * self.scaling
            # temp_result = result * self.lora_sigma.weight.view(-1)
            # result = F.linear(temp_result, transpose(self.svd_u.weight.T, fan_in_fan_out=self.fan_in_fan_out), bias=self.bias)
            # result += ((self.lora_dropout(temp_result.to(self.lora_A_2.weight.dtype)) @ self.lora_A_2.weight.T) @ self.lora_B_2.weight.T) * self.scaling
        else:
            result = F.linear(x, transpose(self.weight, self.fan_in_fan_out), bias=self.bias)

        if result.dtype != previous_dtype:
            result = result.to(previous_dtype)

        return result
    

class MergedLinear(nn.Linear, LoraLayer):
    # Lora implemented in a dense layer
    def __init__(
        self,
        in_features: int,
        out_features: int,
        r: int = 0,
        lora_alpha: int = 1,
        lora_dropout: float = 0.0,
        enable_lora: List[bool] = [False],
        fan_in_fan_out: bool = False,
        merge_weights: bool = True,
        **kwargs,
    ):
        raise NotImplementedError
    

if is_bnb_available():

    class Linear8bitLt(bnb.nn.Linear8bitLt, LoraLayer):
        # Lora implemented in a dense layer
        def __init__(
            self,
            in_features,
            out_features,
            r: int = 0,
            lora_alpha: int = 1,
            lora_dropout: float = 0.0,
            Wdecompose: bool = False,
            **kwargs,
        ):
            raise NotImplementedError

    class MergedLinear8bitLt(bnb.nn.Linear8bitLt, LoraLayer):
        # Lora implemented in a dense layer
        def __init__(
            self,
            in_features: int,
            out_features: int,
            r: int = 0,
            lora_alpha: int = 1,
            lora_dropout: float = 0.0,
            enable_lora: List[bool] = [False],
            **kwargs,
        ):
            raise NotImplementedError
