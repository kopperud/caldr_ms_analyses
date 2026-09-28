#!/usr/bin/env sh
#SBATCH --job-name=palms_caldr_analysis1
#SBATCH --time=0-4:45:00
#SBATCH --mail-type=END
#SBATCH --mail-user=bjorn.kopperud@biol.lu.se
#SBATCH --mem=16G
#SBATCH --output=logs/palms_analysis1.log
#SBATCH --error=logs/palms_analysis1.err
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=lu48

module load GCC/14.3.0
module load R/4.5.2
#module load Rust/1.91.1

Rscript scripts/analysis1.R

