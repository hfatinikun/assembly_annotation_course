#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/hifiasm_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/hifiasm_%j.e

APPTAINER="/containers/apptainer/hifiasm_0.25.0.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
READ=$WORKDIR/Db-1/*.fastq.gz
OUTDIR=$WORKDIR/assembly/hifiasm
mkdir -p $OUTDIR

apptainer exec --bind $WORKDIR,/data/courses $APPTAINER hifiasm -o $OUTDIR/asm -t $SLURM_CPUS_PER_TASK $READ

# Convert any produced GFA(s) to FASTA
for GFA in $OUTDIR/asm*.gfa; do
  [ -f "$GFA" ] || continue
  awk '/^S/{print ">"$2;print $3}' "$GFA" > "${GFA%.gfa}.fa"
done