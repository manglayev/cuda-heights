#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cublas_v2.h>
#include "cublas_1_header.cuh"

//Initialize a vector
void vector_init(float *a)
{
  for(int i = 0; i < N; i++)
  {
    a[i] = (float)(rand() % 100);
  }
}

//Verify the result
void verify_result(float *a, float *b, float *c, float factor)
{
  for(int i = 0; i < N; i++)
  {
    assert(c[i] == factor * a[i] + b[i]);
  }
}
//Verify the result 2
void verify_result(float *d_c, float *h_c)
{
  for(int i = 0; i < N; i++)
  {
    assert(d_c[i] == h_c[i]);
  }
}
float* saxpy(float *a, float *b, float *c, float factor)
{
  for(int i = 0; i < N; i++)
  {
    c[i] = factor * a[i] + b[i];
  }
  return c;
}

//Print N x N matrix
void printArray(float *a)
{
  // loop through array's rows
  for(int i = 0; i < N; i++)
  {
    if(a[i] >= 0)
      std::cout << ' ' << a[i] << ' ';
    else
      std::cout << a[i] << ' ';
  }
  std::cout << '\n'; // start new line of output
}

void wrapper()
{
  printf("STAGE 3 WRAPPER START\n");
  // Vector size
  size_t bytes = N * sizeof(float);
  //Declare vector pointers
  float *h_a, *h_b, *h_c, *h_c_cpu;
  float *d_a, *d_b;

  // Allocate memory
  h_a = (float*)malloc(bytes);
  h_b = (float*)malloc(bytes);
  h_c = (float*)malloc(bytes);
  h_c_cpu = (float*)malloc(bytes);
  
  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);

  // Initialize vectors
  vector_init(h_a);
  vector_init(h_b);

  // Create and initialize a new context
  cublasHandle_t handle;
  cublasCreate_v2(&handle);

  // Copy the vectors over to the device
  cublasSetVector(N, sizeof(float), h_a, 1, d_a, 1);
  cublasSetVector(N, sizeof(float), h_b, 1, d_b, 1);

  // Launch simple saxpy kernel (single precision a * x + y)
  const float scale = 2.0f;
  cublasSaxpy(handle, N, &scale, d_a, 1, d_b, 1);
  
  //Copy the result vector back
  cublasGetVector(N, sizeof(float), d_b, 1, h_c, 1);

  //Saxpy CPU version
  h_c_cpu = saxpy(h_a, h_b, h_c_cpu, scale);
  //Print out the result
  printArray(h_c);
  printArray(h_c_cpu);
  
  //Verify the result
  //verify_result(h_a, h_b, h_c, scale, N);
  // Clean up the created handle
  cublasDestroy(handle);

  // Release allocated memory
  cudaFree(d_a);
  cudaFree(d_b);

  free(h_a);
  free(h_b);
  free(h_c_cpu);
  printf("STAGE 3 WRAPPER END\n");
}