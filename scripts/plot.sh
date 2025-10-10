#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=plotbusco
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/plotbusco_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/plotbusco_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
APPTAINER="/containers/apptainer/busco_6.0.0.sif"
OUTDIR="$WORKDIR/assembly_evaluation/plot_busco"

cd $OUTDIR

apptainer exec --bind $WORKDIR,/data/courses $APPTAINER busco --plot .