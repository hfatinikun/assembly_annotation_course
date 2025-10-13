#!/bin/bash

#SBATCH --time=3-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/trinity_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/trinity_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
READ_LEFT=$(ls $WORKDIR/RNAseq_Sha/*_1*.fastq.gz | paste -sd,)
READ_RIGHT=$(ls $WORKDIR/RNAseq_Sha/*_2*.fastq.gz | paste -sd,)
OUTDIR=$WORKDIR/assembly/trinity
mkdir -p $OUTDIR

module load Trinity/2.15.1-foss-2021a

Trinity --seqType fq --left $READ_LEFT --right $READ_RIGHT --CPU $SLURM_CPUS_PER_TASK --max_memory 64G --output $OUTDIR