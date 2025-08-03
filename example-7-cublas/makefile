NVCC=nvcc
CUDAFLAGS=-arch=sm_70
RM=/bin/rm -f

all: main

main: cublas_1_main.o cublas_1_caller.o cublas_1.o
	g++ cublas_1_main.o cublas_1_caller.o cublas_1.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas

cublas_1_main.o: cublas_1_main.cpp
	g++ -std=c++11 -c cublas_1_main.cpp

cublas_1_caller.o: cublas_1_caller.cpp
	g++ -std=c++11 -c cublas_1_caller.cpp

cublas_1.o: cublas_1.cu
	${NVCC} ${CUDAFLAGS} -c cublas_1.cu

clean:
	${RM} *.o main