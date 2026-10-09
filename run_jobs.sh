#!/bin/bash

#for i in {2..7}; do
#    sbatch "slurm_scripts/mcmc_palms_heterogeneous_extinction_categories_${i}.sh"
#done
#
#for i in {2..7}; do
#    sbatch "slurm_scripts/mcmc_palms_homogeneous_extinction_categories_${i}.sh"
#done

for i in {2..4}; do
    sbatch "slurm_scripts/mcmc_palms_hisse_${i}.sh"
done
