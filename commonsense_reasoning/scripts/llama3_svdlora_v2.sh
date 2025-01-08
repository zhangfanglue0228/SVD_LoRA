# llama3
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B'\
    --data_path './ft-training_set/commonsense_170k.json'\
    --output_dir './outputs/test/llama3_r20'\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-5 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora_v2\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 22 --lora_alpha 44 --use_gradient_checkpointing