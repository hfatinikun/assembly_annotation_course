#!/bin/bash

#SBATCH --job-name=Maker_merge
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/maker_merge/logs/Maker_merge_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/maker_merge/logs/Maker_merge_%j.e

MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
MAKER_INDEX="$WORKDIR/annotation/MAKER/asm.bp.p_ctg.maker.output/asm.bp.p_ctg_master_datastore_index.log"
OUTDIR="$WORKDIR/annotation/MAKER/maker_merge"


mkdir -p $OUTDIR
cd "$OUTDIR"

#Running gff3_merge with sequences
$MAKERBIN/gff3_merge -s -d $MAKER_INDEX > assembly.all.maker.gff

#Running gff3_merge without sequences
$MAKERBIN/gff3_merge -n -s -d $MAKER_INDEX > assembly.all.maker.noseq.gff

#Merging FASTA files
$MAKERBIN/fasta_merge -d $MAKER_INDEX -o assembly