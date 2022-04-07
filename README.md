# cuda_mpi_rank
Check local CUDA rank within OpenMPI.

There are two ways to get local MPI rank within a node to assign a GPU device:
1. getenv: Read an environment variable `OMPI_COMM_WORLD_LOCAL_RANK`
    - This currently works for mpirun
    - But not works for srun
2. split: Use `MPI_Comm_split_type`, reference: [FAQ: Running CUDA-aware Open MPI](https://www.open-mpi.org/faq/?category=runcuda#:~:text=11.%20When%20do%20I%20need%20to%20select%20a%20CUDA%20device%3F)
    - Always works


## Build
Tested on Hipergator
```bash
module load cuda/11.4.3 gcc/9.3.0 openmpi/4.0.5 cmake
make
```

## Sample output
Ran with 4 tasks, 2 nodes, 2 tasks and 2 GPUs for each node.

### 1. [submit_srun_getenv.sh](submit_srun_getenv.sh) (OMPI_COMM_WORLD_LOCAL_RANK is not defined)
```
Date              = Thu Apr  7 18:32:47 EDT 2022
Hostname          = c1106a-s11
Working Directory = /blue/roitberg/jinzexue/dev/cuda_mpi_rank

Number of Nodes Allocated      = 2
Number of Tasks Allocated      = 4
Number of Cores/Task Allocated = 1
GPU Driver '470' detected

submit_srun_cuda_mpi_getenv.sh
OMPI_COMM_WORLD_LOCAL_RANK is not defined
OMPI_COMM_WORLD_LOCAL_RANK is not defined
OMPI_COMM_WORLD_LOCAL_RANK is not defined
OMPI_COMM_WORLD_LOCAL_RANK is not defined
Global Rank: 002 of 004, Local Rank: -01, GPU: -1, Num GPUs: 2, Node: c1110a-s17.ufhpc
Global Rank: 003 of 004, Local Rank: -01, GPU: -1, Num GPUs: 2, Node: c1110a-s17.ufhpc
Global Rank: 000 of 004, Local Rank: -01, GPU: -1, Num GPUs: 2, Node: c1106a-s11.ufhpc
Global Rank: 001 of 004, Local Rank: -01, GPU: -1, Num GPUs: 2, Node: c1106a-s11.ufhpc
```

### 2. [submit_mpirun_getenv.sh](submit_mpirun_getenv.sh)
```
Date              = Thu Apr  7 18:46:01 EDT 2022
Hostname          = c0909a-s11
Working Directory = /blue/roitberg/jinzexue/dev/cuda_mpi_rank

Number of Nodes Allocated      = 2
Number of Tasks Allocated      = 4
Number of Cores/Task Allocated = 1
GPU Driver '470' detected

submit_mpirun_cuda_mpi_getenv.sh
Global Rank: 002 of 004, Local Rank: 000, GPU: 0, Num GPUs: 2, Node: c0909a-s35.ufhpc
Global Rank: 003 of 004, Local Rank: 001, GPU: 1, Num GPUs: 2, Node: c0909a-s35.ufhpc
Global Rank: 000 of 004, Local Rank: 000, GPU: 0, Num GPUs: 2, Node: c0909a-s11.ufhpc
Global Rank: 001 of 004, Local Rank: 001, GPU: 1, Num GPUs: 2, Node: c0909a-s11.ufhpc
```


### 3. [submit_srun_split.sh](submit_srun_split.sh)
```
Date              = Thu Apr  7 18:32:47 EDT 2022
Hostname          = c0800a-s17
Working Directory = /blue/roitberg/jinzexue/dev/cuda_mpi_rank

Number of Nodes Allocated      = 2
Number of Tasks Allocated      = 4
Number of Cores/Task Allocated = 1
GPU Driver '470' detected

submit_srun_cuda_mpi_split.sh
Global Rank: 002 of 004, Local Rank: 000, GPU: 0, Num GPUs: 2, Node: c0801a-s11.ufhpc
Global Rank: 000 of 004, Local Rank: 000, GPU: 0, Num GPUs: 2, Node: c0800a-s17.ufhpc
Global Rank: 001 of 004, Local Rank: 001, GPU: 1, Num GPUs: 2, Node: c0800a-s17.ufhpc
Global Rank: 003 of 004, Local Rank: 001, GPU: 1, Num GPUs: 2, Node: c0801a-s11.ufhpc
```
