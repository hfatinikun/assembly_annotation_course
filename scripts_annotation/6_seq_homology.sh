#!/bin/bash

#SBATCH --job-name=seq_homology
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=1-00:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/homology/logs/seq_homology_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/homology/logs/seq_homology_%j.e

# ------------------ Modules ------------------
module load BLAST+/2.15.0-gompi-2021a

# ------------------ Paths ------------------
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_FINAL="$WORKDIR/annotation/MAKER/final"
MAKERBIN="/data/courses/assembly-annotation-course/CDS_annotation/softwares/Maker_v3.01.03/src/bin"

# Maker outputs (your filenames)
PROT_UNFILTERED="$MAKER_FINAL/assembly.all.maker.proteins.fasta.renamed.fasta"
PROT_FILTERED="$MAKER_FINAL/longest_per_gene_protein.fa"   # use this one
GFF="$MAKER_FINAL/filtered.genes.renamed.gff3"

# Databases (provided by course)
UNIPROT_DB="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa"
TAIR_DB="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_pep_20110103_representative_gene_model"

# Output dir
OUTDIR="$MAKER_FINAL/homology"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

# ------------------ Prepare working copy ------------------
# Work on filtered protein set; keep name simple (NO .Uniprot suffix yet)
cp "$PROT_FILTERED" maker_proteins.fa
cp "$GFF"           maker_genes.gff3

# ------------------ 1) BLASTP vs UniProt ------------------
blastp \
  -query maker_proteins.fa \
  -db "$UNIPROT_DB" \
  -num_threads 10 \
  -outfmt 6 \
  -evalue 1e-5 \
  -max_target_seqs 10 \
  -out uniprot_vs_maker.blastp

# Best hit per query (lowest E-value)
sort -k1,1 -k12,12g uniprot_vs_maker.blastp \
  | sort -u -k1,1 --merge \
  > uniprot_vs_maker.blastp.besthits

# Map UniProt functions into FASTA (OUTPUT gets the .Uniprot suffix)
"$MAKERBIN"/maker_functional_fasta \
  "$UNIPROT_DB" \
  uniprot_vs_maker.blastp.besthits \
  maker_proteins.fa \
  > maker_proteins.fa.Uniprot

# Map UniProt functions into GFF3
"$MAKERBIN"/maker_functional_gff \
  "$UNIPROT_DB" \
  uniprot_vs_maker.blastp.besthits \
  maker_genes.gff3 \
  > maker_genes.Uniprot.gff3

# ------------------ 2) BLASTP vs TAIR10 ------------------
blastp \
  -query maker_proteins.fa \
  -db "$TAIR_DB" \
  -num_threads 10 \
  -outfmt 6 \
  -evalue 1e-5 \
  -max_target_seqs 10 \
  -out tair_vs_maker.blastp

# Best hit per query
sort -k1,1 -k12,12g tair_vs_maker.blastp \
  | sort -u -k1,1 --merge \
  > tair_vs_maker.blastp.besthits



# ------------------ 3) Quick stats ------------------
TOTAL_PROT=$(grep -c "^>" maker_proteins.fa || echo 0)
UNIPROT_HITS=$(cut -f1 uniprot_vs_maker.blastp.besthits | sort -u | wc -l || echo 0)
TAIR_HITS=$(cut -f1 tair_vs_maker.blastp.besthits | sort -u | wc -l || echo 0)

printf "Total MAKER proteins (filtered): %d\n" "$TOTAL_PROT"
awk -v h="$UNIPROT_HITS" -v t="$TOTAL_PROT" 'BEGIN{p=(t>0)?100*h/t:0; printf "With UniProt best hit:        %d (%.2f%%)\n", h, p}'
awk -v h="$TAIR_HITS"    -v t="$TOTAL_PROT" 'BEGIN{p=(t>0)?100*h/t:0; printf "With TAIR10 best hit:         %d (%.2f%%)\n", h, p}'

echo "Outputs:"
echo "  - UniProt BLAST: uniprot_vs_maker.blastp(.besthits)"
echo "  - TAIR10  BLAST: tair_vs_maker.blastp(.besthits)"
echo "  - FASTA w/ UniProt functions: maker_proteins.fa.Uniprot"
echo "  - GFF3  w/ UniProt functions: maker_genes.Uniprot.gff3"
