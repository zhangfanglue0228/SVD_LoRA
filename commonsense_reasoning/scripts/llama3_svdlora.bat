@echo off

:: 脚本说明
:: 在指定的 Conda 环境中运行多个 Python 命令

:: 设置 Conda 环境名称
set ENV_NAME=dora
set DES_DIR=outputs/SVDLoRA_v3/commonsense_170k/32/llama3-8B_L

:: 激活 Conda 环境
call conda activate %ENV_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo activate Conda failed
    exit /b 1
)

echo begin train
python finetune.py ^
    --base_model ../../../models/meta-llama/Meta-Llama-3-8B ^
    --data_path ft-training_set/commonsense_170k.json ^
    --output_dir %DES_DIR% ^
    --batch_size 16  --micro_batch_size 2 --num_epochs 3 ^
    --learning_rate 1e-4 --cutoff_len 256 --val_set_size 120 ^
    --eval_step 200 --save_step 200  --adapter_name svdlora_v3 ^
    --target_modules ["q_proj","k_proj","v_proj","up_proj","down_proj"] ^
    --lora_r 32 --lora_alpha 64 --use_gradient_checkpointing

:: 执行第一个 Python 命令
echo 1st command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset boolq --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/boolq.txt

echo 2nd command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset piqa --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/piqa.txt

echo 3rd command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset social_i_qa --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/social_i_qa.txt

echo 4th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset hellaswag --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/hellaswag.txt

echo 5th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset winogrande --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/winogrande.txt

echo 6th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset ARC-Challenge --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/ARC-Challenge.txt

echo 7th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset ARC-Easy --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/ARC-Easy.txt

echo 8th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_v3 --dataset openbookqa --base_model ../../../models/meta-llama/Meta-Llama-3-8B --batch_size 1 --lora_weights %DES_DIR% | tee -a %DES_DIR%/openbookqa.txt

:: 运行完成
echo success!