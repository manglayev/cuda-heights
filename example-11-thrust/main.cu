#include <cstdio>
#include <iostream>
#include <array>

using namespace std;

/*
    Using a pointer to access data in array
*/

int main()
{
    cout << "main start;\n";
    constexpr size_t size = 5;
    std::array<int, size> a{1, 3, 5, 7, 9};

    int *a_p = a.data();

    printf("a[%d] = %d\n", 3, a[2]);
    printf("a_p[%d] = %d\n", 3, a_p[2]);
    cout << "main end;\n";
}