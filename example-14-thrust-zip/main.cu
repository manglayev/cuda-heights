#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/zip_iterator.h>

using namespace std;

/*
    Example of zip and transform iterator
*/

struct zip_i
{
    int *a;
    int *b;

    std::tuple<int, int> operator[](int i)
    {
        return {a[i], b[i]};
    }
};

struct transform_absolute
{
    zip_i z;
    
    int operator[](int i)
    {
        auto [a, b] = z[i];
        return abs(a - b);
    }
};

int main()
{
    cout << "main start;\n";
    std::array<int, 5> a{1, 33, 5, 77, 9};
    std::array<int, 5> b{11, 3, 55, 7, 99};

    zip_i z {a.data(), b.data()};
    transform_absolute t{z};

    printf("absolute difference of a[%d] = %d and b[%d] = %d is %d\n", 2, a[2], 2, b[2], t[2] );

    cout << "main end;\n";
}