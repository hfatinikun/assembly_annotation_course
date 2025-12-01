#!/bin/bash

#!/bin/bash
#SBATCH --job-name=TEsorter
#SBATCH --time=06:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/TEsorter/logs/TEsorter_%j.log
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/TEsorter/logs/TEsorter_%j.err

# -----------------------------------------
# Set variables
# -----------------------------------------
WORKDIR=/data/users/hfatinikun/assembly_annotation_course/annotation/TEsorter
EDTA_LIB=/data/users/hfatinikun/assembly_annotation_course/annotation/EDTA/asm.bp.p_ctg.fa.mod.EDTA.TElib.fa
CONTAINER=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif

# Load modules
# -----------------------------------------
module load SeqKit/2.6.1

mkdir -p $WORKDIR
cd $WORKDIR

# -----------------------------------------
# Step 1 — Extract Copia & Gypsy sequences
# -----------------------------------------
echo "Extracting Copia sequences..."
seqkit grep -r -p "Copia" $EDTA_LIB > Copia_sequences.fa

echo "Extracting Gypsy sequences..."
seqkit grep -r -p "Gypsy" $EDTA_LIB > Gypsy_sequences.fa


# -----------------------------------------
# Step 2 — Run TEsorter
# -----------------------------------------
mkdir -p output

cd $WORKDIR/output

cd $WORKDIR/output

echo "Running TEsorter on Copia..."
apptainer exec --bind $WORKDIR \
    $CONTAINER \
    TEsorter ../Copia_sequences.fa -db rexdb-plant -pre Copia_rexdb

echo "Running TEsorter on Gypsy..."
apptainer exec --bind $WORKDIR \
    $CONTAINER \
    TEsorter ../Gypsy_sequences.fa -db rexdb-plant -pre Gypsy_rexdb

echo "All tasks completed."