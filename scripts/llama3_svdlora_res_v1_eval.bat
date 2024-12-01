@echo off

:: 脚本说明
:: 在指定的 Conda 环境中运行多个 Python 命令

:: 设置 Conda 环境名称
set ENV_NAME=dora

:: 激活 Conda 环境
call conda activate %ENV_NAME%
if %ERRORLEVEL% NEQ 0 (
    echo activate Conda failed
    exit /b 1
)

:: 执行第一个 Python 命令
echo 1st command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset boolq --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/boolq.txt

echo 2nd command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset piqa --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/piqa.txt

echo 3rd command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset social_i_qa --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/social_i_qa.txt

echo 4th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset hellaswag --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/hellaswag.txt

echo 5th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset winogrande --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/winogrande.txt

echo 6th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset ARC-Challenge --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/ARC-Challenge.txt

echo 7th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset ARC-Easy --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/ARC-Easy.txt

echo 8th command
python commonsense_evaluate.py --model LLaMA3-8B --adapter SVDLoRA_res_v1 --dataset openbookqa --base_model ..\..\models\meta-llama\Meta-Llama-3-8B --batch_size 1 --lora_weights outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B | tee -a outputs/SVDLoRA_res_v1/commonsense_170k/llama3_B/openbookqa.txt

:: 运行完成
echo success!