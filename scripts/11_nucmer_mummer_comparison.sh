#!/bin/bash

#SBATCH --job-name=nucmer_mummer
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/nucmer_mummer_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/nucmer_mummer_%j.e

APPTAINER="/containers/apptainer/mummer4_gnuplot.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"

# assemblies (symlinks in assemblies_final/)
FLYE="$WORKDIR/assembly/flye/assembly.fasta"
HIFIASM="$WORKDIR/assembly/hifiasm/asm.bp.p_ctg.fa"

# reference (actual file present on the course path)
REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

OUTBASE="$WORKDIR/assembly_evaluation/nucmer_mummer"
OUTREF="$OUTBASE/vs_ref"
OUTPAIR="$OUTBASE/pairwise"

mkdir -p "$OUTREF/flye" "$OUTREF/hifiasm" "$OUTPAIR"

# ---------- Flye vs reference ----------
PREFIX="$OUTREF/flye/flye_vs_ref"
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" nucmer --prefix="$PREFIX" --breaklen 1000 --mincluster 1000 "$REF" "$FLYE"

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" mummerplot --png --filter --fat --layout -R "$REF" -Q "$FLYE" -p "$PREFIX" "${PREFIX}.delta"

# ---------- Hifiasm vs reference ----------
PREFIX="$OUTREF/hifiasm/hifiasm_vs_ref"
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" nucmer --prefix="$PREFIX" --breaklen 1000 --mincluster 1000 "$REF" "$HIFIASM"

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" mummerplot --png --filter --fat --layout -R "$REF" -Q "$HIFIASM" -p "$PREFIX" "${PREFIX}.delta"

# ---------- Pairwise: Flye vs Hifiasm ----------
PREFIX="$OUTPAIR/flye_vs_hifiasm"
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" nucmer --prefix="$PREFIX" --breaklen 1000 --mincluster 1000 "$HIFIASM" "$FLYE"

apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" mummerplot --png --filter --fat --layout -R "$HIFIASM" -Q "$FLYE" -p "$PREFIX" "${PREFIX}.delta"