#!/bin/bash

#SBATCH --job-name=pangenome
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=24:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/pangenome_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/pangenome_%j.e


WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
GENESPACE="$WORKDIR/annotation/GENESPACE"
R_SCRIPT="$WORKDIR/scripts_annotation/16.3_process_pangenome.R"

module load R-bundle-IBU/2023072800-foss-2021a-R-4.2.1

cd $GENESPACE

Rscript $R_SCRIPT