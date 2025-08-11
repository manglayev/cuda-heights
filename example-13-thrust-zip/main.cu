#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/zip_iterator.h>

using namespace std;

/*
    Example of zip iterator
*/

struct zip_iterator
{
    int *a;
    int *b;

    std::tuple<int, int> operator[](int i)
    {
        return {a[i], b[i]};
    }
};

int main()
{
    cout << "main start;\n";

    std::array<int, 5> a{1, 3, 5, 7, 9};
    std::array<int, 5> b{10, 30, 50, 70, 90};

    zip_iterator zi = {a.data(), b.data()};

    std::printf("it[0]: (%d, %d)\n", get<0>(zi[0]), get<1>(zi[0]));

    cout << "main end;\n";
}