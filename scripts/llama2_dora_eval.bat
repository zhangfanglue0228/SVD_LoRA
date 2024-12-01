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
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset boolq --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/boolq.txt

echo 2nd command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset piqa --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/piqa.txt

echo 3rd command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset social_i_qa --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/social_i_qa.txt

echo 4th command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset hellaswag --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/hellaswag.txt

echo 5th command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset winogrande --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/winogrande.txt

echo 6th command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset ARC-Challenge --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/ARC-Challenge.txt

echo 7th command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset ARC-Easy --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/ARC-Easy.txt

echo 8th command
python commonsense_evaluate.py --model LLaMA2-7B --adapter DoRA --dataset openbookqa --base_model ..\..\models\meta-llama\Llama-2-7b-hf --batch_size 1 --lora_weights outputs/DoRA/commonsense_170k/llama2-doradora | tee -a outputs/DoRA/commonsense_170k/llama2-doradora/openbookqa.txt

:: 运行完成
echo success!