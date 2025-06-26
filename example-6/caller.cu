#include <iostream>
#include "device_launch_parameters.h"
#include "cuda_runtime.h"

#define THREADS 64
#define BLOCKS 8

using namespace std;

__global__ void reduction(int *input, int *output)
{
    int i = threadIdx.x + blockDim.x * blockIdx.x;
    __shared__ int sdata[THREADS];
    sdata[threadIdx.x] = input[i];
    __syncthreads();

    for(int s = 1; s < blockDim.x; s*=2)
    {
        if(threadIdx.x % (2 * s) == 0)
            sdata[threadIdx.x] += sdata[threadIdx.x + s];
        __syncthreads(); 
    }
    if(threadIdx.x == 0)
        output[blockIdx.x] = sdata[0];
    __syncthreads();
}
/* SIMPLE CUDA REDUCTION PROGRAM */
int main()
{
    int h_a[THREADS * BLOCKS];
    int h_b[1];
    int *d_a;
    int *d_b;

    for(int i = 0; i < THREADS * BLOCKS; i++)
    {
        h_a[i] = 1;
    }

    cudaMalloc((void**)&d_a, THREADS * BLOCKS * sizeof(int));
    cudaMalloc((void**)&d_b, BLOCKS * sizeof(int));

    cudaMemcpy(d_a, h_a, THREADS * BLOCKS * sizeof(int), cudaMemcpyHostToDevice);

    reduction<<<BLOCKS, THREADS>>>(d_a, d_b);
    reduction<<<1, BLOCKS>>>(d_b, d_b);

    cudaMemcpy(h_b, d_b, sizeof(int), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    cout << h_b[0]<<"\n";

    cudaFree(d_a);
    cudaFree(d_b);

}