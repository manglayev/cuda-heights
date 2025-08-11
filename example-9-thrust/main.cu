#include "device_launch_parameters.h"
#include "cuda_runtime.h"

#include <thrust/execution_policy.h>
#include <thrust/universal_vector.h>
#include <thrust/transform.h>
#include <cstdio>
#include <iostream>
using namespace std;

/*
    Simple C++ transform run on the device and lambda
*/

void playing_with_lambda()
{
    int x = 10;
    auto lambda = [=](){ printf("X = %d;\n", x); };
    printf("x = %d;\n", x);
    lambda();

    auto lambda2 = [=]() { return x * 3; };
    int y = lambda2();
    printf("y = %d;\n", y);
}

int main()
{
    cout << "caller start;\n";    
    
    playing_with_lambda();

    size_t N = 5;
    thrust::universal_vector<int> c {N};
    for(int i = 0; i < c.size(); i++)
    {
        c[i] = i * 2;
        printf("%d ", c[i]);
    }
    printf("\n");

    thrust::transform(thrust::device, c.begin(), c.end(), c.begin(), [] __host__ __device__ (int d) { return d * 3; });

    for(int i = 0; i < c.size(); i++)
    {
        printf("%d ", c[i]);
    }
    printf("\n");
    cout << "caller end;\n";
}