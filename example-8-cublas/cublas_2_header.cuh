#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <time.h>
#include <stdio.h>
#include <math.h>

/*
The size of square array must be equal to the multiplication of the number of threads to the number of blocks
THREADS x BLOCKS = CUDASIZE
N x N  = CUDASIZE
*/

#define DIMS 1
/*
#define BLOCKS 4
#define THREADS 8
#define CUDASIZE 32
*/

#define THREADS 32
#define BLOCKS 8
#define CUDASIZE 256
#define N 16
extern void caller();
extern void wrapper();
//void verify_result(float *a, float *b, float *c, float factor);
//void verify_result(float *d_c, float *h_c);
void verify_result(float *a, float *b, float *c);
void printArray(float *a);