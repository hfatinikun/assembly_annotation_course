#!/bin/bash

#SBATCH --job-name=assembly_samtools
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/assembly_samtools_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/assembly_samtools_%j.e

APPTAINER="/containers/apptainer/samtools-1.19.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
HIFIASM="$WORKDIR/assembly/hifiasm/asm.bp.p_ctg.fa"
OUTDIR="$WORKDIR/annotation/visualize_TE_annotation"

mkdir -p $OUTDIR 
mkdir -p "$OUTDIR/logs"

cd $OUTDIR

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" samtools faidx "$HIFIASM" --output hifiasm.fai