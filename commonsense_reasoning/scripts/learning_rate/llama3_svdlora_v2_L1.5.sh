# llama3
# './outputs/SVDLoRA_v2/commonsense_170k/21/llama2_L1.5'
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir $2\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-5 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora_v2\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 16 --lora_alpha 32 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset boolq \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset piqa \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset social_i_qa \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset hellaswag \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset winogrande \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset ARC-Challenge \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset ARC-Easy \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset openbookqa \
    --base_model '../../../models/meta-llama/Llama-2-7b-hf' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/openbookqa.txt