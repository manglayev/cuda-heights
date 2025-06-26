#include <iostream>
#include "device_launch_parameters.h"
#include "cuda_runtime.h"
#include "cuda.h"

using namespace std;
__global__ void doubleArray(int *a, int N)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    for(int i = index; i < N; i += stride)
    {
        a[i] = a[i] * 2;
    }
}

void print(int *a, int N)
{
    int c = 0;
    for(int i = 0; i < N; i++)
    {
        c++;
        cout<<a[i]<<" ";
        if (c % 8 == 0) cout <<"\n";
    }
}

int main()
{
    int N = 2 << 7;
    size_t size = N * sizeof(int);
    
    int h_a[N];    
    for(int i = 0; i < N; i++)
    {
        h_a[i] = 1;
    }

    int *d_a;
    cudaMalloc((void**)&d_a, size);
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    
    doubleArray<<<2,4>>>(d_a, N);
    
    cudaMemcpy(h_a, d_a, size, cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    
    cudaFree(d_a);
    
    print(h_a, N);
}