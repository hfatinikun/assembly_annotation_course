#!/bin/bash

#SBATCH --job-name=maker_opts
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/logs/maker_opts_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/logs/maker_opts_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/annotation/MAKER"

mkdir -p "$OUTDIR"

cd "$OUTDIR"

apptainer exec --bind $WORKDIR /data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif maker -CTL