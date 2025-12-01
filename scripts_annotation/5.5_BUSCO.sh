#!/bin/bash

#SBATCH --job-name=BUSCO_anno
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=5:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/BUSCO/logs/BUSCO_anno_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/BUSCO/logs/BUSCO_anno_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_DIR="$WORKDIR/annotation/MAKER/final"
LONG_PROTEIN="$MAKER_DIR/longest_per_gene_protein.fa"
LONG_TRANSCRIPT="$MAKER_DIR/longest_per_gene_transcript.fa"
TRINITY="/data/users/hfatinikun/assembly_annotation_course/assembly/trinity.Trinity.fasta"
BUSCODIR="$WORKDIR/annotation/BUSCO"

mkdir -p $BUSCODIRc
cd $BUSCODIR

module load BUSCO/5.4.2-foss-2021a

busco -i "$LONG_PROTEIN" -l brassicales_odb10 -o busco_output_proteins -m proteins
busco -i "$LONG_TRANSCRIPT" -l brassicales_odb10 -o busco_output_transcriptome -m transcriptome
busco -i "$TRINITY" -l brassicales_odb10 -o busco_output_trinity -m transcriptome