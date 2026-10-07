#!/bin/bash

for i in {2..7}; do
    file_basename="mcmc_palms_homogeneous_extinction_categories_${i}"

    content="#!/usr/bin/env sh
#SBATCH --job-name=palms_homogeneous_extinction_${i}
#SBATCH --time=0-20:45:00
#SBATCH --mail-type=END
#SBATCH --mail-user=bjorn.kopperud@biol.lu.se
#SBATCH --mem=16GB
#SBATCH --output=logs/${file_basename}.log
#SBATCH --error=logs/${file_basename}.err
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --partition=lu48

module load GCC/14.3.0
module load R/4.5.2

Rscript scripts/mcmc_palms_homogeneous_extinction_categories.R ${i}
    "

    echo "$content" > "slurm_scripts/${file_basename}.sh"
done


