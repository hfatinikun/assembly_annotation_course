#!/bin/bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=kmer_jellyfish
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/kmer_jf_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/kmer_jf_%j.e

APPTAINER="/containers/apptainer/jellyfish:2.2.6--0"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
INDIR="/data/users/hfatinikun/assembly_annotation_course/Db-1"
OUTDIR=$WORKDIR/reads/kmer
mkdir -p $OUTDIR

#Count canoical k=21 k-mers (hash 5G, 4 threads) using substitution(zcat) 
apptainer exec --bind $WORKDIR,$INDIR,/data/courses $APPTAINER jellyfish count -m 21 -C -s 5G -t 4 -o $OUTDIR/mer_counts.jf <(zcat $INDIR/*.fastq.gz)

#Build histogram for Genomescope
apptainer exec --bind $WORKDIR,$INDIR,/data/courses $APPTAINER jellyfish histo -t 4 $OUTDIR/mer_counts.jf > reads.histo

echo "Done. Upload $OUTDIR/reads.histo to https://genomescope.org/genomescope2.0/ (k=21)."
