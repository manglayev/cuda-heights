#include <iostream>
#include "device_launch_parameters.h"
#include "cuda_runtime.h"

using namespace std;

__global__ void init(int *a, int N)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    for(int i = id; i < N; i += stride)
    {
        a[i] = 1;
    }
}

__global__ void sum(int *a, int *b, int *c, int N)
{
    int id = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    for(int i = id; id < N; i += stride)
    {
        c[i] = a[i] + b[i];
    }
}

void print(int *a, int N)
{
    int c = 0;
    for(int i = 0; i < N; i++)
    {
        cout << a[i] << " ";
        c++;
        if(c % 8 == 0) cout << "\n";
    }
}

int main()
{
    int *a;
    int *b;
    int *c;

    int N = 2<<7;
    size_t size = N * sizeof(int);

    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    int deviceId;
    int number_of_SMs;

    cudaGetDevice(&deviceId);
    cudaDeviceGetAttribute(&number_of_SMs, cudaDevAttrMultiProcessorCount, deviceId);

    cudaMemPrefetchAsync(&a, size, deviceId);
    cudaMemPrefetchAsync(&b, size, deviceId);
    cudaMemPrefetchAsync(&c, size, deviceId);

    init<<<8, 32>>>(a, N);
    init<<<8, 32>>>(b, N);
    init<<<8, 32>>>(c, N);
      
    sum<<<8, 32>>>(a, b, c, N);

    cudaDeviceSynchronize();
    cudaMemPrefetchAsync(c, size, cudaCpuDeviceId);
    print(c, N);

    //printf("number of multi processors: %d\n", number_of_SMs);
    
    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}