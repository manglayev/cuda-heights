#include <iostream>
#include "device_launch_parameters.h"
#include "cuda_runtime.h"

using namespace std;

__global__ void init(int *a, int N)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    for (int i = index; i < N; i += stride)
    {
        a[i] = 1;
    }
}

__global__ void summ(int *a, int *b, int *c, int N)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;

    for(int i = index; i < N; i+= stride)
    {
        c[i] = a[i] + b[i];
    }
}

void print(int *a, int N)
{
    int c = 0;
    for (int i = 0; i < N; i++)
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

    const int N = 2 << 7;
    size_t size = N * sizeof(int);
    
    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);
    
    int deviceId;
    int numberOfSMs;

    cudaGetDevice(&deviceId);
    cudaDeviceGetAttribute(&numberOfSMs, cudaDevAttrMultiProcessorCount, deviceId);

    cudaMemPrefetchAsync(a, size, deviceId);
    cudaMemPrefetchAsync(b, size, deviceId);
    cudaMemPrefetchAsync(c, size, deviceId);

    cudaStream_t stream_1;
    cudaStream_t stream_2;
    cudaStream_t stream_3;
    
    cudaStreamCreate(&stream_1);
    cudaStreamCreate(&stream_2);
    cudaStreamCreate(&stream_3);    

    init<<<8, 32, 0, stream_1>>>(a, N);
    init<<<8, 32, 0, stream_2>>>(b, N);
    init<<<8, 32, 0, stream_3>>>(c, N);

    cudaStreamDestroy(stream_1);
    cudaStreamDestroy(stream_2);
    cudaStreamDestroy(stream_3);

    summ<<<8, 32>>>(a, b, c, N);

    cudaMemPrefetchAsync(c, size, cudaCpuDeviceId);
    print(c, N);

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}