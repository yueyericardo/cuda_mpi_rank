C=nvcc
MPICXX=mpicxx
MPIRUN ?= mpirun
CUDA_HOME ?= /usr/local/cuda
GENCODE_SM30    := -gencode arch=compute_30,code=sm_30
GENCODE_SM35    := -gencode arch=compute_35,code=sm_35
GENCODE_SM37    := -gencode arch=compute_37,code=sm_37
GENCODE_SM50    := -gencode arch=compute_50,code=sm_50
GENCODE_SM52    := -gencode arch=compute_52,code=sm_52
GENCODE_SM60    := -gencode arch=compute_60,code=sm_60
GENCODE_SM70    := -gencode arch=compute_70,code=sm_70
GENCODE_SM80    := -gencode arch=compute_80,code=sm_80 -gencode arch=compute_80,code=compute_80
GENCODE_FLAGS   := $(GENCODE_SM70) $(GENCODE_SM80)
ifdef DISABLE_CUB
	NVCC_FLAGS = -Xptxas --optimize-float-atomics
else
	NVCC_FLAGS = -DHAVE_CUB
endif
ifdef SKIP_CUDA_AWARENESS_CHECK
	MPICXX_FLAGS = -DSKIP_CUDA_AWARENESS_CHECK
endif
NVCC_FLAGS += -lineinfo $(GENCODE_FLAGS) -std=c++14
MPICXX_FLAGS += -DUSE_NVTX -I$(CUDA_HOME)/include -std=c++14
LD_FLAGS = -L$(CUDA_HOME)/lib64 -lcudart -lnvToolsExt


all: cuda_mpi_rank_getenv cuda_mpi_rank_split 

cuda_mpi_rank_getenv: Makefile cuda_mpi_rank_getenv.cpp 
	$(MPICXX) $(MPICXX_FLAGS) cuda_mpi_rank_getenv.cpp $(LD_FLAGS) -o cuda_mpi_rank_getenv 

cuda_mpi_rank_split: Makefile cuda_mpi_rank_split.cpp
	$(MPICXX) $(MPICXX_FLAGS) cuda_mpi_rank_split.cpp $(LD_FLAGS) -o cuda_mpi_rank_split 
