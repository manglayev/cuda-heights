#include "example-2-header.h"
#include "device_launch_parameters.h"
#include "cuda_runtime.h"

__global__ void kernel(int *a, int *b, int *c, int N)
{
    //printf("GPU kernel start");
    int index = threadIdx.x;
    if (index < N)
    {
        c[index] = a[index] + b[index];
    }
    //printf("GPU kernel end");
}

void init(int *a, int N)
{
    for(int i = 0; i < N; i++)
    {
        a[i] = 1;
    }
}

void print(int *a, int N)
{
    for(int i = 0; i < N; i++)
    {
        cout<<a[i]<<" ";
    }
    cout << "\n";
}
void caller()
{
    cout<<"caller start\n";
    
    int *a;
    int *b;
    int *c;
    const int N = 1<<4;
    cout<<N<<"\n";
    size_t size = N * sizeof(int);

    cudaMallocManaged(&a, size);
    cudaMallocManaged(&b, size);
    cudaMallocManaged(&c, size);

    init(a, N);
    init(b, N);

    kernel<<<1, N>>>(a, b, c, N);

    cudaDeviceSynchronize();

    print(c, N);

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
    
    cout<<"caller end\n";
}