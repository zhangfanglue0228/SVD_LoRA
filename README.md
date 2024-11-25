# SVD_LoRA

💪Try adding SVD to LoRA💪

## First Try

### Implement

1. SVD is applied to the matrix, get $U$, $\Sigma$, $V$ matrices
2. Using LoRA in $U$ matrix

### Results
Bad😔

## Second Try

### SVDLoRA

SVD is applied to the matrix, get $U$, $\Sigma$, $V$ matrices

The difference between the fine-tuned $U \Sigma V$ matrix and the original $U \Sigma V$ matrix is used as LoRA

+ $W^\prime = W_0 + \Delta W = W_0 + (\underline{U \Sigma V} - {U \Sigma V}_{original})$
+ $\Delta W = (\underline{U \Sigma V} - {U \Sigma V}_{original})$

#### Results

+ Better than LoRA, worse than DoRA

+ However, it was found that there may be a shortened training time effect

## Third Try

1. Add Residual to SVDLoRA
    1. coefficient = 0 / 1 (sigmoid)
    2. coefficient = 0 ~ 1
    3. coefficient = (-∞, +∞)
2. SVDDoRA