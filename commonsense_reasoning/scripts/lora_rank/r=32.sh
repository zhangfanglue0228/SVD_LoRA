# llama3
# './outputs/SVDLoRA/commonsense_170k/32/llama_B'
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/yahma/llama-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir $2\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset boolq \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset piqa \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset social_i_qa \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset hellaswag \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset winogrande \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset ARC-Challenge \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset ARC-Easy \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA-7B \
    --adapter SVDLoRA \
    --dataset openbookqa \
    --base_model '../../../models/yahma/llama-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/openbookqa.txt