#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/zip_iterator.h>
#include <thrust/universal_vector.h>

using namespace std;

/*
    Example of thrust zip iterator
*/

int main() 
{
  constexpr int N{5};
  thrust::universal_vector<int> a{N};
  thrust::universal_vector<int> b{N};

  for(int i = 0; i < N; i++)
  {
    a[i] = i;
    b[i] = i * i;
  }

  auto zip = thrust::make_zip_iterator(a.begin(), b.begin());

  auto transform = thrust::make_transform_iterator(zip,
  [] __host__ __device__ (thrust::tuple<int, int> t)
  {
    return abs(thrust::get<0>(t) - thrust::get<1>(t));
  });

  printf("transform = %d\n", *transform);

  transform++;
  transform++;
  
  printf("transform = %d\n", *transform);

  printf("b[%d] = %d\n", 2, b[2]);
}