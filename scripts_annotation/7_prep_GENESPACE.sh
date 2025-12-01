#!/bin/bash
# prepare_genespace_inputs.sh

#SBATCH --job-name=prep_GENESPACE
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=24:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/prep_GENESPACE_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE/logs/prep_GENESPACE_%j.e

# Minimal script to prepare BED and peptide FASTA files for GENESPACE.

# ===== EDIT THESE =====
WD="/data/users/hfatinikun/assembly_annotation_course/annotation/GENESPACE"
YOURACC="Db-1"
YOURACC_GFF="/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/filtered.genes.renamed.gff3"
YOURACC_PEP="/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/longest_per_gene_protein.fa"

COURSEDIR="/data/courses/assembly-annotation-course"
TAIR10_BED="$COURSEDIR/CDS_annotation/data/TAIR10.bed" 
TAIR10_PEP="$COURSEDIR/CDS_annotation/data/TAIR10.fa"

ACC_FA_DIR="$COURSEDIR/CDS_annotation/data/Lian_et_al/protein/selected"
ACC_GFF_DIR="$COURSEDIR/CDS_annotation/data/Lian_et_al/gene_gff/selected"
EXTRA=("Altai-5" "Ice-1" "Taz-0")   # add/remove as you like
# =======================

mkdir -p "$WD/bed" "$WD/peptide"

# --- Your accession: GFF -> BED (0-based start), then copy peptide FASTA ---
awk -F'\t' -v OFS='\t' '
  $0 !~ /^#/ && $3=="gene" {
    split($9,a,";"); id=""
    for(i in a){split(a[i],b,"="); if(id=="" && (b[1]=="ID" || b[1]=="Name")) id=b[2]}
    if(id!="") print $1, $4-1, $5, id
  }' "$YOURACC_GFF" > "$WD/bed/${YOURACC}.bed"

cp "$YOURACC_PEP" "$WD/peptide/${YOURACC}.fa"

# --- TAIR10 reference ---
cp "$TAIR10_BED" "$WD/bed/TAIR10.bed"
cp "$TAIR10_PEP" "$WD/peptide/TAIR10.fa"

# --- Extra accessions (prefix-match to real filenames like Altai-5.EVM....gff/.fa) ---
# --- Extra accessions (match real filenames: *.protein.faa and *.gff) ---
# Keep as-is for input matching, but when WRITING files use underscores:
for acc in "${EXTRA[@]}"; do
  out=${acc//-/_}   # Altai-5 -> Altai_5, etc.
  gff=$(ls "$ACC_GFF_DIR/${acc}."*.gff | head -n1)
  fa="$ACC_FA_DIR/${acc}.protein.faa"

  awk -F'\t' -v OFS='\t' '
    $0 !~ /^#/ && $3=="gene" {
      split($9,a,";"); id=""
      for(i in a){split(a[i],b,"="); if(id=="" && (b[1]=="ID" || b[1]=="Name")) id=b[2]}
      if(id!="") print $1, $4-1, $5, id
    }' "$gff" > "$WD/bed/${out}.bed"

  cp "$fa" "$WD/peptide/${out}.fa"
done

# --- Genome list for GENESPACE ---
printf "%s\n" "$YOURACC" "TAIR10" "${EXTRA[@]}" > "$WD/genomes.list"

echo "Prepared inputs in $WD:"
echo " - bed/"
echo " - peptide/"
echo " - genomes.list"
