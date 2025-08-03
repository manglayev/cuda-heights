NVCC=nvcc
CUDAFLAGS=-arch=sm_70
RM=/bin/rm -f

all: main

main: cublas_2_main.o cublas_2_caller.o cublas_2.o
	g++ cublas_2_main.o cublas_2_caller.o cublas_2.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas -lcurand

cublas_2_main.o: cublas_2_main.cpp
	g++ -std=c++11 -c cublas_2_main.cpp

cublas_2_caller.o: cublas_2_caller.cpp
	g++ -std=c++11 -c cublas_2_caller.cpp

cublas_2.o: cublas_2.cu
	${NVCC} ${CUDAFLAGS} -c cublas_2.cu

clean:
	${RM} *.o main