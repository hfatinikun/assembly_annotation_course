#!/bin/bash
#SBATCH --job-name=TE_dynamics
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/TE_dynamics/logs/TE_dynamics_%j.log
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/TE_dynamics/logs/TE_dynamics_%j.err

GENOME_PREFIX=asm.bp.p_ctg.fa.mod

EDTA_ANNO=/data/users/hfatinikun/assembly_annotation_course/annotation/EDTA/asm.bp.p_ctg.fa.mod.EDTA.anno
WORKDIR=/data/users/hfatinikun/assembly_annotation_course/annotation/TE_dynamics
REPEATMASKER_OUT=/data/users/hfatinikun/assembly_annotation_course/annotation/EDTA/asm.bp.p_ctg.fa.mod.EDTA.anno/asm.bp.p_ctg.fa.mod.out

PARSER=/data/users/hfatinikun/assembly_annotation_course/scripts_annotation/4.1-parseRM.pl
RSCRIPT=/data/users/hfatinikun/assembly_annotation_course/scripts_annotation/4.2-plot_div.R

mkdir -p $WORKDIR/logs
cd $WORKDIR

echo "Working directory: ${WORKDIR}"
echo "EDTA anno dir:     ${EDTA_ANNO}"
echo "RepeatMasker file: ${REPEATMASKER_OUT}"


module add BioPerl/1.7.8-GCCcore-10.3.0
module load R-bundle-IBU/2023072800-foss-2021a-R-4.2.1


# Step 1 — Parse RepeatMasker output
perl $PARSER -i $REPEATMASKER_OUT -l 50,1 -v

echo "parseRM.pl finished."

# parseRM.pl usually produces a file based on the input name.
# Here we assume an output like: ${GENOME_PREFIX}.out.parseRM
# If the name is slightly different (e.g. .divsum), just adjust INPUT_PARSE below.

# -----------------------------------------
# Step 2 — TE landscape plot with plot_div.R
# -----------------------------------------

# Make sure the Plots directory exists
mkdir -p $WORKDIR/Plots

Rscript $RSCRIPT

echo "TE dynamics / landscape plot completed."
