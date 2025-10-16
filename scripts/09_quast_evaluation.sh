#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=quast
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/quast_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/quast_%j.e

APPTAINER="/containers/apptainer/quast_5.2.0.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/assembly_evaluation/quast"
mkdir -p "$OUTDIR"

REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
GFF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.57.gff3"

FLYE="$WORKDIR/assembly/flye/assembly.fasta"
HIFIASM="$WORKDIR/assembly/hifiasm/asm.bp.p_ctg.fa"

# === Run QUAST without reference ===
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" quast.py "$FLYE" "$HIFIASM" --eukaryote --threads 16 --labels Flye,Hifiasm -o "$OUTDIR/no_ref" -f

# === Run QUAST with reference ===
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" quast.py "$FLYE" "$HIFIASM" --eukaryote --threads 16 --labels Flye,Hifiasm -R "$REF" --features "$GFF" -o "$OUTDIR/with_ref" -f