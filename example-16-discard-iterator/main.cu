#include <cstdio>
#include <iostream>
#include <array>

#include <thrust/iterator/zip_iterator.h>

using namespace std;

/*
    Example of discard iterator
*/

struct wrapper
{
   void operator=(int value)
   {
      // discard value
   }
};

struct discard_iterator 
{
  wrapper operator[](int i) 
  {
    return {};
  }
};

int main() 
{
  discard_iterator it{};

  it[0] = 10;
  it[1] = 20;
  
  printf("it[%d] = %d;\n", 0, it[0]);
  printf("it[%d] = %d;\n", 1, it[1]);
}