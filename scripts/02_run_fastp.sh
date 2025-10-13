#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastp
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/fastp_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/fastp_%j.e

APPTAINER="/containers/apptainer/fastp_0.24.1.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR=$WORKDIR/reads/fastp
mkdir -p $OUTDIR


# RNA-seq (paired-end)
apptainer exec --bind $WORKDIR,/data/courses $APPTAINER fastp \
  -i $WORKDIR/RNAseq_Sha/ERR754081_1.fastq.gz \
  -I $WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz \
  -o $OUTDIR/ERR754081_1.trimmed.fastq.gz \
  -O $OUTDIR/ERR754081_2.trimmed.fastq.gz \
  -h $OUTDIR/RNAseq_fastp.html \
  -j $OUTDIR/RNAseq_fastp.json

# PacBio HiFi (single-end, stats only)
apptainer exec --bind $WORKDIR,/data/courses $APPTAINER fastp \
  -i $WORKDIR/Db-1/ERR11437307.fastq.gz \
  -o /dev/null \
  -h $OUTDIR/Db-1_fastp.html \
  -j $OUTDIR/Db-1_fastp.json