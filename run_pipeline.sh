#!/bin/bash
#SBATCH -J sm
#SBATCH -o out
#SBATCH -e err
#SBATCH -p shared
#SBATCH -n 1
#SBATCH -t 1-00:00
#SBATCH --mem=10000

CONDA_BASE=$(conda info --base)
source $CONDA_BASE/etc/profile.d/conda.sh
conda activate mySnakemake
snakemake --snakefile workflow/Snakefile --profile ./profiles/slurm
