#include <cstdio>
#include <iostream>
#include <array>

using namespace std;

/*
    Example of count iterator
*/

struct count_iterator
{
    int operator[](int i)
    {
        return i;
    }
};

int main()
{
    cout << "main start;\n";
    count_iterator ci;

    printf("ci[%d] = %d\n", 0, ci[0]);
    printf("ci[%d] = %d\n", 5, ci[5]);
    cout << "main end;\n";
}