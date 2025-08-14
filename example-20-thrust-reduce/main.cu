#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/sequence.h>
#include <thrust/universal_vector.h>
#include <thrust/execution_policy.h>

using namespace std;

/*
    Example of thrust zip reduce iterator
*/

void max_change(const thrust::universal_vector<int> &a, const thrust::universal_vector<int> &b)
{
    auto zip = thrust::make_zip_iterator(a.begin(), b.begin());

    auto transformation = [] __host__ __device__ (thrust::tuple<int, int> t)
    {
        return abs(thrust::get<0>(t) - thrust::get<1>(t));
    };

    auto transform = make_transform_iterator(zip, transformation);

    float m = thrust::reduce(thrust::device, transform, transform + a.size(), 0.0f, thrust::maximum<float>{});

    printf("max change % 2.f\n", m);

}

int main()
{
    // allocate vectors containing 2^28 elements
    thrust::universal_vector<int> a(1 << 8);
    thrust::universal_vector<int> b(1 << 8);

    thrust::sequence(a.begin(), a.end());
    thrust::sequence(b.rbegin(), b.rend());

    max_change(a, b);
}