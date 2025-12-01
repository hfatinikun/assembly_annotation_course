#!/bin/bash

#SBATCH --job-name=visualize_TE_annotation
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/visualize_TE_annotation/logs/visualize_TE_annotation_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/visualize_TE_annotation/logs/visualize_TE_annotation_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
SCRIPT="scripts_annotation/2_TE_annotation_circlize.R"
OUTDIR="$WORKDIR/annotation/visualize_TE_annotation"

mkdir -p $OUTDIR

cd $OUTDIR

module load R-bundle-IBU/2023072800-foss-2021a-R-4.2.1 #works with circilze

Rscript $WORKDIR/$SCRIPT 