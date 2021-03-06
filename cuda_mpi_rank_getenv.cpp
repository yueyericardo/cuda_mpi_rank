    /*------------------------------------------------------------------------------------------------
cuda_mpi_rank

Modified from https://github.com/olcf-tutorials/local_mpi_to_gpu
------------------------------------------------------------------------------------------------*/

#include <stdio.h>
#include <sched.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>
#include <iostream>


int main(int argc, char *argv[])
{

    /* -------------------------------------------------------------------------------------------
        MPI Initialization
    --------------------------------------------------------------------------------------------*/
    MPI_Init(&argc, &argv);

    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    char name[MPI_MAX_PROCESSOR_NAME];
    int resultlength;
    MPI_Get_processor_name(name, &resultlength);

    /* -------------------------------------------------------------------------------------------
        Find local rank by reading environment variable
    --------------------------------------------------------------------------------------------*/
    int local_rank = -1;
    const char* nl_rank = getenv("OMPI_COMM_WORLD_LOCAL_RANK");
    if (nl_rank) {
        local_rank = atoi(nl_rank);
    } else {
        std::cerr << "OMPI_COMM_WORLD_LOCAL_RANK is not defined" << std::endl;
    }

    /* -------------------------------------------------------------------------------------------
        Other Initialization
    --------------------------------------------------------------------------------------------*/
    // Find hardware thread being used by each MPI rank
    int hwthread = sched_getcpu();

    // Find how many GPUs CUDA runtime says are available
    int num_devices = 0;
    cudaGetDeviceCount(&num_devices);

    // Map MPI ranks to GPUs according to node-local MPI rank (round-robin)
    int gpu_id = local_rank % num_devices;
    int real_gpu_id = -1;

    if (gpu_id >= 0 && num_devices) {
        // Set cuda device
        cudaSetDevice(gpu_id);
        // Check which GPU each MPI rank is actually mapped to
        cudaGetDevice(&real_gpu_id);
    }

    /* -------------------------------------------------------------------------------------------
        Output and finalize
    --------------------------------------------------------------------------------------------*/

    // Each MPI rank will print its details.
    printf("Global Rank: %03d of %03d, Local Rank: %03d, GPU: %01d, Num GPUs: %01d, Node: %s\n", rank, size, local_rank, real_gpu_id, num_devices, name);

    MPI_Finalize();

    return 0;
}