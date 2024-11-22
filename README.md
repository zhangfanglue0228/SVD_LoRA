# SVD_LoRA

💪Try adding SVD to LoRA💪

## First Try

### Implement

1. SVD is applied to the matrix, get $U$, $\Sigma$, $V$ matrices
2. Using LoRA in $U$ matrix

### Results
Bad😔

## Second Try

SVD is applied to the matrix, get $U$, $\Sigma$, $V$ matrices

### v1

Initialize LoRA using the matrix obtained from SVD

+ $W^\prime = W_0 + \Delta W = W_0 + \underline{U \Sigma V}$
+ $\Delta W = \underline{U \Sigma V}$

### v2

The difference between the fine-tuned $U \Sigma V$ matrix and the original $U \Sigma V$ matrix is used as LoRA

+ $W^\prime = W_0 + \Delta W = W_0 + (\underline{U \Sigma V} - {U \Sigma V}_{original})$
+ $\Delta W = (\underline{U \Sigma V} - {U \Sigma V}_{original})$

### v3

The matrix obtained after recovering the difference between the fine-tuned U and V matrices and their respective original matrices is used as LoRA

+ $W^\prime = W_0 + \Delta W = W_0 + (\underline U - U_{original})(\underline {\Sigma} - {\Sigma}_{original})(\underline V - V_{original})$
+ $\Delta W = (\underline U - U_{original})(\underline {\Sigma} - {\Sigma}_{original})(\underline V - V_{original})$
