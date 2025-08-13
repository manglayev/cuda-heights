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

  thrust::universal_vector<int> a {N};
  thrust::universal_vector<int> b {N};

  for(int i = 0; i < N; i++)
  {
    a[i] = i;
    b[i] = i * i;
  }

  auto zip = thrust::make_zip_iterator(a.begin(), b.begin());

  thrust::tuple<int, int> z1 = *zip;
  printf("z1<0><1> = <%d, %d>\n", thrust::get<0>(z1), thrust::get<1>(z1));
  
  zip++;
  
  thrust::tuple<int, int> z2 = *zip;
  printf("z1<0><1> = <%d, %d>\n", thrust::get<0>(z2), thrust::get<1>(z2));
}