#!/bin/bash

# Submit this script with: sbatch <this-filename>
#SBATCH --time=20:05:00   # walltime # about 3hrs for ~300 seqs, 20+ hrs for 7000+
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem 30GB   # memory per node
#SBATCH -J tree.e%j   # job name

# Notify at the beginning, end of job and on failure.
#SBATCH --mail-user=zshivji@caltech.edu   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

## /SBATCH -p general # partition (queue)
## /SBATCH -o slurm.%N.%j.out # STDOUT
## /SBATCH -e slurm.%N.%j.err # STDERR

echo "====================================================="
echo "Start Time  : $(date)"
echo "Submit Dir  : $SLURM_SUBMIT_DIR"
echo "Job ID/Name : $SLURM_JOBID / $SLURM_JOB_NAME"
echo "Node List   : $SLURM_JOB_NODELIST"
echo "Num Tasks   : $SLURM_NTASKS total [$SLURM_NNODES nodes @ $SLURM_CPUS_ON_NODE CPUs/node]"
echo "======================================================"
echo ""

# load env, software
eval "$(conda shell.bash hook)"
conda activate make_trees

module load mafft/7.505-gcc-13.2.0-nklkvtc

echo "clustering"
# grab nif superfamily
cat ../diazoDB-HPC/results/checked_nifDKEN.fasta ../diazoDB-HPC/SSN/PF00148-unreviewed.fasta > SSN/diazoDB-checkedDKEN_PF00148-unreviewed.fasta

# cluster
mmseqs easy-cluster SSN/diazoDB-checkedDKEN_PF00148-unreviewed.fasta SSN/clustered_DKEN_90 tmp --min-seq-id 0.90 -c 0.8 --cov-mode 0

# count clusters
num=$(grep ">" SSN/diazoDB-checkedDKEN_PF00148-unreviewed.fasta | wc -l)
echo "$num clusters for 0.90"

echo ""
echo "======================================================"
echo "End Time   : $(date)"
echo "======================================================"
echo ""
