#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/flye_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/flye_%j.e

APPTAINER="/containers/apptainer/flye_2.9.5.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
READ=$WORKDIR/Db-1/*.fastq.gz
OUTDIR=$WORKDIR/assemblies/flye
mkdir -p $OUTDIR

apptainer exec --bind $WORKDIR,/data/courses $APPTAINER flye --pacbio-hifi $READ --genome-size 3g --threads $SLURM_CPUS_PER_TASK --out-dir $OUTDIR