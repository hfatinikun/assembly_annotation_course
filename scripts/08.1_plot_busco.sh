#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --job-name=plot_busco
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/plot_busco_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/plot_busco_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
APPTAINER="/containers/apptainer/busco_6.0.0.sif"
OUTDIR="$WORKDIR/assembly_evaluation/busco"

#INPUT1="$OUTDIR/flye/flye_busco/short_summary.specific.brassicales_odb10.flye_busco.json"
#INPUT2="$OUTDIR/hifiasm/hifiasm_busco/short_summary.specific.brassicales_odb10.hifiasm_busco.json"
#INPUT3="$OUTDIR/trinity/trinity_busco/short_summary.specific.brassicales_odb10.trinity_busco.json"

cd $OUTDIR

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" busco --plot "$OUTDIR/json_files"