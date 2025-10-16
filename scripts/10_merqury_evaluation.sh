#!/bin/bash
#SBATCH --job-name=merqury
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/merqury_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/merqury_%j.e

APPTAINER_MERQURY="/containers/apptainer/merqury_1.3.sif"
APPTAINER_MERYL="/containers/apptainer/meryl_1.4.1.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"

OUTDIR="$WORKDIR/assembly_evaluation/merqury"
FLYE="$WORKDIR/assembly/flye/assembly.fasta"
HIFIASM="$WORKDIR/assembly/hifiasm/asm.bp.p_ctg.fa"

READS="$WORKDIR"/Db-1/*.fastq.gz

k=21

mkdir -p "$OUTDIR"
cd "$OUTDIR"

export MERQURY="/usr/local/share/merqury"

# ---------- 1) Build k-mer DB once ----------
READ_DB="$OUTDIR/reads.k${k}.meryl"
if [[ ! -d "$READ_DB" ]]; then
  apptainer exec --bind "$WORKDIR,$OUTDIR,/data" "$APPTAINER_MERYL" meryl k="$k" count $READS output "$READ_DB"
fi

# ---------- 2) Run Merqury for each assembly ----------
# FLYE
mkdir -p "$OUTDIR/flye/logs"
cd "$OUTDIR/flye"
apptainer exec --bind "$WORKDIR,$OUTDIR,/data" "$APPTAINER_MERQURY" merqury.sh "$READ_DB" "$FLYE" flye

# HIFIASM
mkdir -p "$OUTDIR/hifiasm/logs"
cd "$OUTDIR/hifiasm"
apptainer exec --bind "$WORKDIR,$OUTDIR,/data" "$APPTAINER_MERQURY" merqury.sh "$READ_DB" "$HIFIASM" hifiasm