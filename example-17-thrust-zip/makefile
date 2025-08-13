NVCC = nvcc --extended-lambda
CUDAFLAGS = -arch=sm_70
RM = /bin/rm -f

all: main

main: main.o
	g++ main.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas -lcurand

main.o: main.cu
	${NVCC} ${CUDAFLAGS} -c main.cu
clean:
	${RM} *.o main