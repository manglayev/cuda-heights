#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/zip_iterator.h>

using namespace std;

/*
    Example of transform and output iterator
*/

struct transform_i
{
    int *a;
    void operator=(int i)
    {
        *a = i / 2;
    }
};

struct output_i
{
    int *a;
    
    transform_i operator[](int i)
    {
        return {a + i};
    }
};

int main()
{
    cout << "main start;\n";
    std::array<int, 5> a;
    output_i oi = {a.data()};
    
    oi[0] = 10;
    oi[1] = 20;

    printf("a[%d] = %d; a[%d] = %d; \n", 0, a[0], 1, a[1] );

    cout << "main end;\n";
}