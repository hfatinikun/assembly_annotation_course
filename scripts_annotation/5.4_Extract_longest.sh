#!/bin/bash

#SBATCH --job-name=Extract_longest
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=5:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/logs/Extract_longest_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/logs/Extract_longest_%j.e

WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_DIR="$WORKDIR/annotation/MAKER/final"
PROTEIN="/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/assembly.all.maker.proteins.fasta.renamed.filtered.fasta"
TRANSCRIPT="/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/final/assembly.all.maker.transcripts.fasta.renamed.filtered.fasta"

cd $MAKER_DIR
module load SeqKit/2.6.1

# Extract Longest Protein per Gene
seqkit fx2tab $PROTEIN \
| awk -F'\t' '{len=length($2); split($1,a,"-R"); gene=a[1]; if(len>max[gene]){max[gene]=len; seq[gene]=$0}} END{for(i in seq) print seq[i]}' \
| seqkit tab2fx > longest_per_gene_protein.fa

seqkit fx2tab $TRANSCRIPT \
| awk -F'\t' '{len=length($2); split($1,a,"-R"); gene=a[1]; if(len>max[gene]){max[gene]=len; seq[gene]=$0}} END{for(i in seq) print seq[i]}' \
| seqkit tab2fx > longest_per_gene_transcript.fa