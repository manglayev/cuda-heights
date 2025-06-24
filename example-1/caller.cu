#include "example-1-header.h"
#include "device_launch_parameters.h"
#include "cuda_runtime.h"

__global__ void kernel()
{
    printf("GPU kernel\n");
}

void caller()
{
    cout << "caller start;\n";
    kernel<<<1,1>>>();
    cudaDeviceSynchronize();
    cout << "caller end;\n";
}