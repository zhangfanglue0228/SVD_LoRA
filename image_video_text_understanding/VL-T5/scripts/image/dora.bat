@echo off

set task=multitask

:: or bart
set model=bart

echo %model%

if "%model%"=="t5" (
    set folder_prefix=VLT5
    set backbone=..\..\models\google-t5\t5-base
    set batch_size=400
) else if "%model%"=="bart" (
    set folder_prefix=VLBart
    set backbone=..\..\..\models\facebook\bart-base
    set batch_size=300
)

echo %folder_prefix%
echo %backbone%

set feature=RN101

set lr=1e-3

set lora_dim=128

set project_name=%feature%_LMsingle_dora_%lora_dim%_bs%batch_size%_image224_lora_settings
set run_name=tune+lr%lr%_plzplz2
set output=snap\%folder_prefix%_%task%\%run_name%

set TOKENIZERS_PARALLELISM=True
set PYTHONPATH=%PYTHONPATH%;.\src

python -m torch.distributed.launch ^
    --nproc_per_node=%1 ^
    --master_port=26464 ^
    .\VL-T5\src\%task%.py ^
    --distributed --multiGPU ^
    --optim adamw ^
    --warmup_ratio 0.1 ^
    --clip_grad_norm 5 ^
    --lr %lr% ^
    --epochs 20 ^
    --num_workers 4 ^
    --backbone %backbone% ^
    --output %output% %* ^
    --num_beams 5 ^
    --use_tasks_prompts ^
    --batch_size %batch_size% ^
    --valid_batch_size %batch_size% ^
    --use_dora ^
    --unfreeze_bias ^
    --unfreeze_layer_norms ^
    --lora_settings ^
    --lora_dim %lora_dim% ^
    --tasks "vqa,gqa,nlvr,caption" ^
    --feature %feature% --n_boxes 36 --downsample ^
    --image_size "(224,224)" ^
    --project_name %project_name% ^
    --run_name %run_name%
