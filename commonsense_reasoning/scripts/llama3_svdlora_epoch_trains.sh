# llama3
# ./outputs/SVDLoRA_C/commonsense_170k/32/llama3
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 1\
    --learning_rate 5e-5 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset boolq \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset piqa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset social_i_qa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset hellaswag \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset winogrande \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset ARC-Challenge \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset ARC-Easy \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset openbookqa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_1'/openbookqa.txt


# llama3
# ./outputs/SVDLoRA_C/commonsense_170k/32/llama3
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 2\
    --learning_rate 5e-5 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset boolq \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/boolq.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset piqa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/piqa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset social_i_qa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/social_i_qa.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset hellaswag \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/hellaswag.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset winogrande \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/winogrande.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset ARC-Challenge \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/ARC-Challenge.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset ARC-Easy \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/ARC-Easy.txt

CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset openbookqa \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'|tee -a './outputs/SVDLoRA_C/commonsense_170k/epoches_trains/llama3_2'/openbookqa.txt