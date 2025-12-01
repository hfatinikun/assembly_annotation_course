#!/bin/bash

#SBATCH --job-name=run_GENESPACE
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=24:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/run_GENESPACE_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/run_GENESPACE_%j.e


WORKDIR="/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE"
GENESPACER="/data/users/hfatinikun/assembly_annotation_course/scripts_annotation/16_GENESPACE.R"
CONTAINER="/data/courses/assembly-annotation-course/CDS_annotation/containers/genespace_latest.sif"

cd $WORKDIR
apptainer exec --bind /data --bind $SCRATCH:/temp $CONTAINER Rscript $GENESPACER $WORKDIR