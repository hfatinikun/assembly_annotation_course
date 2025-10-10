#!/bin/bash
#SBATCH --job-name=merqury
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=FAIL
#SBATCH --cpus-per-task=16
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/merqury_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/merqury_%j.e

set -euo pipefail

APPTAINER="/containers/apptainer/merqury_1.3.sif"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
FLYE="$WORKDIR/assemblies_final/flye.fa"
HIFI="$WORKDIR/assemblies_final/hifiasm.fa"
READS="$WORKDIR/Db-1/"*.fastq.gz          # HiFi reads
OUTDIR="$WORKDIR/assembly_evaluation/merqury"
GENOMESIZE=135000000
THREADS="${SLURM_CPUS_PER_TASK:-8}"

mkdir -p "$OUTDIR" "$OUTDIR/logs"
export MERQURY="/usr/local/share/merqury"

echo "Finding best k for genome size ${GENOMESIZE}..."
# Robust parse: take the last integer printed by best_k.sh
BESTK_TXT="$OUTDIR/best_k.txt"
apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
  sh -c '"$MERQURY/best_k.sh" '"$GENOMESIZE"' 0.001' | tee "$BESTK_TXT"
K=$(grep -Eo '[0-9]+' "$BESTK_TXT" | tail -n1)
# Fallback if parse failed (or you want to pin K manually)
if [[ -z "${K:-}" ]]; then K=21; fi
echo "Using K=$K"

# Build meryl db for reads (once). meryl can read .gz in this container; if not, switch to zcat process-substitution.
if [[ ! -d "$OUTDIR/hifi.meryl" ]]; then
  echo "Counting reads -> hifi.meryl ..."
  apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
    meryl count k="$K" threads="$THREADS" $READS output "$OUTDIR/hifi.meryl"
else
  echo "Reusing $OUTDIR/hifi.meryl"
fi

cd "$OUTDIR"

run_one () {
  local ASM_FA="$1"                       # absolute path to assembly fasta
  local PREFIX
  PREFIX="$(basename "${ASM_FA%.*}")"     # flye or hifiasm
  local ASM_MERYL="$OUTDIR/${PREFIX}.meryl"
  local OUTPREFIX="${PREFIX}_out"

  if [[ ! -d "$ASM_MERYL" ]]; then
    echo "Counting $ASM_FA -> $ASM_MERYL ..."
    apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
      meryl count k="$K" threads="$THREADS" "$ASM_FA" output "$ASM_MERYL"
  else
    echo "Reusing $ASM_MERYL"
  fi

  echo "Running Merqury for $PREFIX ..."
  # IMPORTANT: pass the assembly FASTA as 4th arg to avoid meryl-lookup segfaults
  apptainer exec --bind "$WORKDIR,/data/courses" "$APPTAINER" \
    "$MERQURY/merqury.sh" "$OUTDIR/hifi.meryl" "$ASM_MERYL" "$OUTPREFIX" "$ASM_FA"
  echo "Done: $PREFIX"
}

run_one "$FLYE"
run_one "$HIFI"
