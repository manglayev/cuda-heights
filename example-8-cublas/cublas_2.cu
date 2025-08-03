#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cublas_v2.h>
#include <curand.h>
#include "cublas_2_header.cuh"

//Verify the result 3
void verify_result(float *a, float *b, float *c)
{
  float temp;
  float epsilon = 0.001;;
  for(int i = 0; i < N; i++)
  {
    for(int j = 0; j < N; j++)
    {
      temp = 0;
      for(int k = 0; k < N; k++)
      {
        temp += a[k * N + i] * b[j * N + k];
      }
      assert(fabs(c[j * N + i] - temp) < epsilon);
    }    
  }
}
/*
//Print N x N matrix
*/
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
  size_t bytes = N * N * sizeof(float);
  //Declare vector pointers
  float *h_a, *h_b, *h_c;
  float *d_a, *d_b, *d_c;

  // Allocate memory
  h_a = (float*)malloc(bytes);
  h_b = (float*)malloc(bytes);
  h_c = (float*)malloc(bytes);
  
  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);
  cudaMalloc(&d_c, bytes);

  //pseudorandom number generator
  curandGenerator_t prng;
  curandCreateGenerator(&prng, CURAND_RNG_PSEUDO_DEFAULT);
  
  //set the seed
  curandSetPseudoRandomGeneratorSeed(prng, (unsigned long long)clock());

  //Fill the matrix with the random number on the device
  curandGenerateUniform(prng, d_a, N*N);
  curandGenerateUniform(prng, d_b, N*N);
  
  // Create and initialize a new context
  cublasHandle_t handle;
  cublasCreate(&handle);

  float alpha = 1.0f;
  float beta = 0.0f;

  cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, N, N, N, &alpha, d_a, N, d_b, N, &beta, d_c, N);

  cudaMemcpy(h_a, d_a, bytes, cudaMemcpyDeviceToHost);
  cudaMemcpy(h_b, d_b, bytes, cudaMemcpyDeviceToHost);
  cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

  
  verify_result(h_a, h_b, h_c);
  //Print out the result
  printArray(h_c);

  //Clean up the created handle
  cublasDestroy(handle);
  printf("STAGE 3 WRAPPER END\n");
}