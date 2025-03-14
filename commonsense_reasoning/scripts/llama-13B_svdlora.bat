@echo off

:: 脚本说明
:: 在指定的 Conda 环境中运行多个 Python 命令

:: 设置 Conda 环境名称
set ENV_NAME=dora
set DES_DIR=outputs/SVDLoRA_C/commonsense_170k/32/llama13


:: 激活 Conda 环境
call conda activate %ENV_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo activate Conda failed
    exit /b 1
)

echo begin train
python finetune.py ^
    --base_model ../../../models/yahma/llama-13b-hf ^
    --data_path ft-training_set/commonsense_170k.json ^
    --output_dir %DES_DIR% ^
    --batch_size 16  --micro_batch_size 2 --num_epochs 3 ^
    --learning_rate 3e-4 --cutoff_len 256 --val_set_size 120 ^
    --eval_step 200 --save_step 200  --adapter_name svdlora ^
    --target_modules ["q_proj","k_proj","v_proj","up_proj","down_proj"] ^
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

:: 执行第一个 Python 命令
echo 1st command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/boolq.txt

echo 2nd command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset piqa --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/piqa.txt

echo 3rd command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset social_i_qa --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/social_i_qa.txt

echo 4th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset hellaswag --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/hellaswag.txt

echo 5th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset winogrande --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/winogrande.txt

echo 6th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset ARC-Challenge --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/ARC-Challenge.txt

echo 7th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset ARC-Easy --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/ARC-Easy.txt

echo 8th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset openbookqa --base_model ../../../models/yahma/llama-13b-hf --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/openbookqa.txt

:: 运行完成
echo success!