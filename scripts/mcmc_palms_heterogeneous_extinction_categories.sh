#!/usr/bin/env sh
#SBATCH --job-name=palms_heterogeneous_extinction
#SBATCH --time=0-5:45:00
#SBATCH --mail-type=END
#SBATCH --mail-user=bjorn.kopperud@biol.lu.se
#SBATCH --mem=16GB
#SBATCH --output=logs/mcmc_palms_heterogeneous_extinction_categories.log
#SBATCH --error=logs/mcmc_palms_heterogeneous_extinction_categories.err
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --partition=lu48

module load GCC/14.3.0
module load R/4.5.2
#module load Rust/1.91.1

Rscript scripts/mcmc_palms_heterogeneous_extinction_categories.R
