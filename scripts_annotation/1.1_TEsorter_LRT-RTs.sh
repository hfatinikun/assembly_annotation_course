#!/bin/bash

#SBATCH --job-name=TEsorter
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=20
#SBATCH --time=2-00:00:00
#SBATCH --mem=128G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/TEsorter_LRT-RTs/logs/TEsorter_LRT-RTs_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/TEsorter_LRT-RTs/logs/TEsorter_LRT-RTs_%j.e

APPTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
READS="$WORKDIR/annotation/EDTA/asm.bp.p_ctg.fa.mod.EDTA.raw/asm.bp.p_ctg.fa.mod.LTR.raw.fa"
OUTDIR="$WORKDIR/annotation/TEsorter_LRT-RTs"

mkdir -p "$OUTDIR"

cd "$OUTDIR"

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" TEsorter "$READS" -db rexdb-plant -p "$SLURM_CPUS_PER_TASK"