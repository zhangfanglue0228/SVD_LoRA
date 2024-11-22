# llama3
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/epoches_train/llama3-svdinitlora_v2_170k'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 1\
    --learning_rate 1e-4 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdinitlora_v2\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing