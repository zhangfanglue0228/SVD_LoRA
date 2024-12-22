CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset boolq \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset piqa \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset social_i_qa \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset hellaswag \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset winogrande \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset ARC-Challenge \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset ARC-Easy \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter LoRA \
    --dataset openbookqa \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/openbookqa.txt