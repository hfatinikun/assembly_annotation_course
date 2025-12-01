#!/bin/bash
#SBATCH --job-name=maker_test
#SBATCH --mail-user=heritage.fatinikun@students.unibe.ch
#SBATCH --mail-type=END,FAIL
#SBATCH --partition=pshort_el8
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=4
#SBATCH --time=00:10:00
#SBATCH --mem=5G
#SBATCH --output=/data/users/hfatinikun/assembly_annotation_course/test_maker_%j.out
#SBATCH --error=/data/users/hfatinikun/assembly_annotation_course/test_maker_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/hfatinikun/assembly_annotation_course"
OUTDIR="$WORKDIR/annotation/MAKER"


REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

cd "$OUTDIR"

# Augustus + RepeatMasker
module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec -n 4 apptainer exec --bind $SCRATCH:/TMP --bind "$COURSEDIR" --bind "$WORKDIR,/data/courses" --bind "$AUGUSTUS_CONFIG_PATH" --bind "$REPEATMASKER_DIR" "$COURSEDIR/containers/MAKER_3.01.03.sif" maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl

