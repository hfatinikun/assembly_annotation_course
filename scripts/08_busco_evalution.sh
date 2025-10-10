#!/bin/bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=busco
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/busco_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/busco_%j.e

module load BUSCO/5.4.2-foss-2021a

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/assembly_evaluation/busco/"
mkdir -p $OUTDIR

declare -A MODE=( ["flye"]="genome" ["hifiasm"]="genome" ["trinity"]="transcriptome" )

for ASM in flye hifiasm trinity; do
    
    INPUT="${WORKDIR}/assemblies_final/$ASM.fa"
    RESULT="$OUTDIR/$ASM"
    mkdir -p $RESULT

    busco \
      -i $INPUT \
      -o "${ASM}_busco" \
      --mode "${MODE[$ASM]}" \
      --auto-lineage \
      --cpu 16 \
      --out_path $RESULT
done

echo "BUSCO finished. Results under $OUTDIR/*" 

