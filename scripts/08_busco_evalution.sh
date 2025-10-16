#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=busco
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/busco_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/busco_%j.e

APPTAINER="/containers/apptainer/busco_6.0.0.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
INDIR="$WORKDIR/assembly"
OUTDIR="$WORKDIR/assembly_evaluation/busco"
LINEAGE="$WORKDIR/brassicales_odb10"

mkdir -p $OUTDIR

declare -A FILES=(
  [flye]="$INDIR/flye/assembly.fasta"
  [hifiasm]="$INDIR/hifiasm/asm.bp.p_ctg.fa"
  [trinity]="$INDIR/trinity.Trinity.fasta"
)

declare -A MODE=(
  [flye]="genome"
  [hifiasm]="genome"
  [trinity]="transcriptome"
)

for ASM in flye hifiasm trinity; do
  apptainer exec --bind "$WORKDIR",/data/courses "$APPTAINER" busco -i "${FILES[$ASM]}" -o "${ASM}_busco" --mode "${MODE[$ASM]}" -l "$LINEAGE" --offline --cpu "$SLURM_CPUS_PER_TASK" --out_path "$OUTDIR/$ASM"  -f
done