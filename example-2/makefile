NVCC = nvcc
CUDAFLAGS = -arch=sm_70
RM = /bin/rm -f

all: main

main: main.o caller.o
	g++ main.o caller.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas

main.o: main.cpp
	g++ -std=c++11 -c main.cpp

caller.o: caller.cu
	${NVCC} ${CUDAFLAGS} -c caller.cu

clean:
	${RM} *.o main