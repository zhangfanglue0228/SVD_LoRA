CUDA_VISIBLE_DEVICES=$1 python commonsense_evaluate.py \
    --model LLaMA3-8B \
    --adapter SVDLoRA \
    --dataset boolq \
    --base_model '../../models/meta-llama/Meta-Llama-3-8B' \
    --batch_size 1 \
    --lora_weights $2|tee -a $2/boolq.txt