#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/fastqc_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/fastqc_%j.e

APPTAINER="/containers/apptainer/fastqc-0.12.1.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR=$WORKDIR/reads/fastqc
mkdir -p $OUTDIR

apptainer exec --bind $WORKDIR,/data/courses $APPTAINER fastqc -o $OUTDIR $WORKDIR/Db-1/*.fastq.gz $WORKDIR/RNAseq_Sha/*.fastq.gz