# Notes
```bash
# request node
srun --partition=hpg-ai --reservation=hackathon --account=nvidia-ai --qos=nvidia-ai --gpus=8 --ntasks-per-node=8 --nodes=1 --ntasks=8 --cpus-per-task=2 --mem=80gb -t 10:00:00 --pty /bin/bash -i
# build
module load gcc/9.3.0 openmpi/4.0.4 cuda/11.1.0
mpicc -I/apps/compilers/cuda/11.1.0/include -L/apps/compilers/cuda/11.1.0/lib64 -lcudart local_mpi_to_gpu.cpp -o local_mpi_to_gpu
# run
module load gcc/9.3.0 openmpi/4.0.4 cuda/11.1.0
mpirun -np 8 local_mpi_to_gpu
```

output
```
Global Rank: 004 of 008, Local Rank: 004, HWThread 003, GPU: 4 Node: c1006a-s23.ufhpc
Global Rank: 002 of 008, Local Rank: 002, HWThread 007, GPU: 2 Node: c1006a-s23.ufhpc
Global Rank: 006 of 008, Local Rank: 006, HWThread 128, GPU: 6 Node: c1006a-s23.ufhpc
Global Rank: 007 of 008, Local Rank: 007, HWThread 132, GPU: 7 Node: c1006a-s23.ufhpc
Global Rank: 001 of 008, Local Rank: 001, HWThread 133, GPU: 1 Node: c1006a-s23.ufhpc
Global Rank: 000 of 008, Local Rank: 000, HWThread 005, GPU: 0 Node: c1006a-s23.ufhpc
Global Rank: 005 of 008, Local Rank: 005, HWThread 006, GPU: 5 Node: c1006a-s23.ufhpc
Global Rank: 003 of 008, Local Rank: 003, HWThread 001, GPU: 3 Node: c1006a-s23.ufhpc
```
