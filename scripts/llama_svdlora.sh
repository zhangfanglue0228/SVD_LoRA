# llama
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/yahma/llama-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA/commonsense_170k/16/llama-svdlora_new'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 2e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 16 --lora_alpha 32 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/yahma/llama-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA/commonsense_170k/8/llama-svdlora_new_B'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 8 --lora_alpha 16 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/yahma/llama-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA/commonsense_170k/4/llama-svdlora_new_B'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 4 --lora_alpha 8 --use_gradient_checkpointing