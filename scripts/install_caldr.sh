#!/usr/bin/env sh
#SBATCH --job-name=install_caldr
#SBATCH --time=0-0:45:00
#SBATCH --mail-type=END
#SBATCH --mail-user=bjorn.kopperud@biol.lu.se
#SBATCH --mem=16GB
#SBATCH --output=logs/install_caldr.log
#SBATCH --error=logs/install_caldr.err
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --partition=lu48

module load GCC/14.3.0
module load R/4.5.2
module load Rust/1.91.1

Rscript -e 'remotes::install_local("~/caldr", force = TRUE)' 
