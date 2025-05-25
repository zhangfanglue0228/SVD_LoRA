# llama3
# './outputs/SVDLoRA_C/commonsense_170k/32/llama3_L1.5'
CUDA_VISIBLE_DEVICES=$1 python finetune.py \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B'\
    --data_path './ft-training_set/math_10k.json'\
    --output_dir $2\
    --batch_size 16  --micro_batch_size 2 --num_epochs 3\
    --learning_rate 3e-5 --cutoff_len 256 --val_set_size 120\
    --eval_step 200 --save_step 200  --adapter_name svdlora\
    --target_modules '["q_proj","k_proj","v_proj","up_proj","down_proj"]'\
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset addsub \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/addsub.txt

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset aqua \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/aqua.txt

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset gsm8k \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/gsm8k.txt

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset multiarith \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/multiarith.txt

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset singleeq \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/singleeq.txt

CUDA_VISIBLE_DEVICES=$1 python math_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA_v2 \
    --dataset svamp \
    --base_model '../../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/svamp.txt