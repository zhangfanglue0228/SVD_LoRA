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
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/boolq.txt

echo 2nd command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/piqa.txt

echo 3rd command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/social_i_qa.txt

echo 4th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/hellaswag.txt

echo 5th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/winogrande.txt

echo 6th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/ARC-Challenge.txt

echo 7th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/ARC-Easy.txt

echo 8th command
python commonsense_evaluate.py --model LLaMA-13B --adapter SVDLoRA --dataset boolq --base_model ..\..\models\yahma\llama-13b-hf --batch_size 1 --lora_weights outputs/llama-13B-svdinitlora_v2_170k_B | tee -a outputs/llama-13B-svdinitlora_v2_170k_B/openbookqa.txt

:: 运行完成
echo success!