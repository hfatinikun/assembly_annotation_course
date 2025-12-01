#!/bin/bash

#SBATCH --job-name=Maker_gene_annotation
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --time=7-0
#SBATCH --mem=120G
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/logs/Maker_gene_annotation_%j.o
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/annotation/MAKER/logs/Maker_gene_annotation_%j.e

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/annotation/MAKER"

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

cd $OUTDIR

module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec --bind $SCRATCH:/TMP --bind $COURSEDIR --bind "$WORKDIR,/data/courses" --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR ${COURSEDIR}/containers/MAKER_3.01.03.sif maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl