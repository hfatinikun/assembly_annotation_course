#!/bin/bash

#SBATCH --time=3-00:00:00
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=lja
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/lja_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/lja_%j.e

APPTAINER="/containers/apptainer/lja-0.2.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
READ=$WORKDIR/Db-1/*.fastq.gz
OUTDIR=$WORKDIR/assembly/lja
mkdir -p $OUTDIR

apptainer exec --bind $WORKDIR,/data/courses $APPTAINER lja -o $OUTDIR --reads $READ -t $SLURM_CPUS_PER_TASK 
