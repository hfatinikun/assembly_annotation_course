#!/bin/bash

#SBATCH --job-name=LTR-RTs
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/LTR-RTs/logs/LTR-RTs_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/LTR-RTs/logs/LTR-RTs_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
SCRIPT="scripts_annotation/1.2_LTR-RTs.R"
OUTDIR="$WORKDIR/annotation/LTR-RTs"

# Use a per-project user library for R packages (writable)
export R_LIBS_USER="$WORKDIR/.Rlibs/4.3"
mkdir -p "$R_LIBS_USER"

# Load R
module load R/4.3.2-foss-2021a

mkdir -p "$OUTDIR/plots"

cd "$OUTDIR"

# Run the R script
Rscript "$WORKDIR/$SCRIPT"