#!/bin/bash

#SBATCH --job-name=AGAT
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=20G
#SBATCH --partition=pibu_el8
#SBATCH --time=2:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/logs/AGAT_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/logs/AGAT_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_DIR="$WORKDIR/annotation/MAKER/final"
CONTAINER="/containers/apptainer/agat-1.2.0.sif"

cd $MAKER_DIR

apptainer exec --bind /data $CONTAINER agat_sp_statistics.pl -i filtered.genes.renamed.gff3 -o annotation.stat