#include <cstdio>
#include <iostream>
#include <array>

using namespace std;

/*
    Example of iterator
*/

struct transform_iterator
{
    int *a;
    int operator[](int i)
    {
        return i * i;
    }
};

int main()
{
    cout << "main start;\n";
    std::array<int, 5> a{1, 3, 5, 7, 9};
    int *a_p = a.data();
    transform_iterator ti{a.data()};
    
    printf("ti[%d] = %d\n", 0, ti[0]);
    printf("ti[%d] = %d\n", 3, ti[3]);

    printf("a[%d] = %d\n", 0, a[0]);
    printf("a[%d] = %d\n", 3, a[3]);

    printf("a_p[%d] = %d\n", 0, a[0]);
    printf("a_p[%d] = %d\n", 3, a[3]);

    cout << "main end;\n";
}