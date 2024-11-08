CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --data_path './ft-training_set/commonsense_15k.json' \
    --output_dir './outputs/llama3-svdlora-2' \
    --batch_size 8  --micro_batch_size 4 --num_epochs 3 \
    --learning_rate 5e-5 --cutoff_len 256 --val_set_size 120 \
    --eval_step 50 --save_step 50  --adapter_name svdlora \
    --target_modules '["q_proj", "k_proj", "v_proj", "up_proj", "down_proj"]' \
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing