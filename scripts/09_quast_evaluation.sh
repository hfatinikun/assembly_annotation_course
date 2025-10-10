#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=quast
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/quast_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/quast_%j.e

APPTAINER="/containers/apptainer/quast_5.2.0.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/assembly_evaluation/quast"
mkdir -p "$OUTDIR"

# Use the actual files present in /data/courses/assembly-annotation-course/references
REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"   # (.fa.gz also available)
GFF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.57.gff3"

FLYE="$WORKDIR/assemblies_final/flye.fa"
HIFI="$WORKDIR/assemblies_final/hifiasm.fa"

# === Run QUAST without reference ===
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
  quast.py "$FLYE" "$HIFI" \
  --eukaryote \
  --threads 16 \
  --labels Flye,Hifiasm \
  -o "$OUTDIR/no_ref"

# === Run QUAST with reference ===
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
  quast.py "$FLYE" "$HIFI" \
  --eukaryote \
  --threads 16 \
  --labels Flye,Hifiasm \
  -R "$REF" \
  --features "$GFF" \
  -o "$OUTDIR/with_ref"

echo "QUAST finished. Reports:"
echo "  $OUTDIR/no_ref/report.html"
echo "  $OUTDIR/with_ref/report.html"
