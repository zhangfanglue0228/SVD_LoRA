# llama
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/yahma/llama-7b-hf'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/SVDLoRA/commonsense_170k/llama-svdlora_new_B'\
    --batch_size 16  --micro_batch_size 4 --num_epochs 3\
    --learning_rate 3e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing