#!/bin/bash

#SBATCH --job-name=EDTA
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=20
#SBATCH --time=3-00:00:00
#SBATCH --mem=128G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/EDTA_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/EDTA_%j.e

APPTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA2.2.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
HIFIASM="$WORKDIR/assembly/hifiasm/asm.bp.p_ctg.fa"
REF="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated"
OUTDIR="$WORKDIR/annotation/EDTA"

mkdir -p "$OUTDIR"

cd "$OUTDIR"

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" EDTA.pl --genome "$HIFIASM" --species others --step all --sensitive 1 --cds "$REF" --anno 1 --threads 20 --force 1
