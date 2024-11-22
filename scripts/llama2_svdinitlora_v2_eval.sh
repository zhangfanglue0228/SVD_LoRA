CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset boolq \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset piqa \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset social_i_qa \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset hellaswag \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset winogrande \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset ARC-Challenge \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset ARC-Easy \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA2-7B \
    --adapter SVDinitLoRA_v2 \
    --dataset openbookqa \
    --base_model '../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/openbookqa.txt