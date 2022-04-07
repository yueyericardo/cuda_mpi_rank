#!/bin/bash
#SBATCH --job-name=mpi_cuda_test     # Job name
#SBATCH --ntasks=4                   # Number of MPI tasks (i.e. processes)
#SBATCH --nodes=2                    # Maximum number of nodes to be allocated
#SBATCH --ntasks-per-node=2          # Maximum number of tasks on each node
#SBATCH --cpus-per-task=1            # Number of cores per MPI task 
#SBATCH --gres=gpu:2                 # Number of GPUs per Node
#SBATCH --partition=hpg-ai
#SBATCH --mem-per-cpu=10gb           # Memory (i.e. RAM) per processor
#SBATCH --time=00:05:00              # Wall time limit (days-hrs:min:sec)
#SBATCH --output=log_srun_getenv_%j.log     # Path to the standard output and error files relative to the working directory

echo "Date              = $(date)"
echo "Hostname          = $(hostname -s)"
echo "Working Directory = $(pwd)"
echo ""
echo "Number of Nodes Allocated      = $SLURM_JOB_NUM_NODES"
echo "Number of Tasks Allocated      = $SLURM_NTASKS"
echo "Number of Cores/Task Allocated = $SLURM_CPUS_PER_TASK"

module load cuda/11.4.3 gcc/9.3.0 openmpi/4.0.5 cmake
echo 
echo submit_srun_cuda_mpi_getenv.sh
srun --mpi=pmix_v3 /blue/roitberg/jinzexue/dev/cuda_mpi_rank/cuda_mpi_rank_getenv
