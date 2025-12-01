#!/bin/bash

#SBATCH --job-name=Filtering_and_Refining
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=05:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/Filtering_and_Refining_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/Filtering_and_Refining_%j.e

# --- Paths ---
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_DIR="$WORKDIR/annotation/MAKER"
MAKER_MERGE="$MAKER_DIR/maker_merge"

prefix="Db-1"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

# --- 1) Prepare workspace & copy inputs ---
cd $MAKER_DIR
mkdir -p final
cd $MAKER_MERGE

cp $gff $MAKER_DIR/final/${gff}.renamed.gff
cp $protein $MAKER_DIR/final/${protein}.renamed.fasta
cp $transcript $MAKER_DIR/final/${transcript}.renamed.fasta

cd $MAKER_DIR/final

# --- 2) Assign clean, consistent IDs (IMPORTANT: these tools write to STDOUT) ---
# Create ID map
$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map

# Apply map to GFF and FASTAs
$MAKERBIN/map_gff_ids id.map ${gff}.renamed.gff
$MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
$MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta


# --- 3) InterProScan on proteins (Pfam only, as you set) ---
# Note: ensure the bound interproscan data path exists
apptainer exec \
  --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
  --bind $WORKDIR \
  --bind $SCRATCH:/temp \
  $COURSEDIR/containers/interproscan_latest.sif \
  /opt/interproscan/interproscan.sh \
  -appl pfam --disable-precalc -f TSV \
  --goterms --iprlookup --seqtype p \
  -i ${protein}.renamed.fasta -o output.iprscan

# --- 4) Update GFF with InterProScan results ---
$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff

# --- 5) AED values (uses the mapped GFF with renamed IDs) ---
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > assembly.all.maker.renamed.mapped.gff.AED.txt

# --- 6) Quality filter (AED<1 and/or Pfam present) ---
perl $MAKERBIN/quality_filter.pl -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff

# --- 7) Keep only gene-related features ---
# (Use egrep for portability; -P can be flaky on some nodes)
# Get mRNA IDs
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
# Check
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# Subset FASTAs to those mRNAs only
module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

grep -P "\tmRNA\t" filtered.genes.renamed.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > list.txt

faSomeRecords ${transcript}.renamed.fasta list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta list.txt ${protein}.renamed.filtered.fasta