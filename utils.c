/* Utility functions for Matrix Multiplication Program

Alex Angus

6/10/22
*/

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define KERNEL_PATH "kernels.cl"

char* getKernelSource(){
  /* read kernel file into string buffer */
  char* buffer = 0;
  long length;
  FILE* f = fopen(KERNEL_PATH, "rb");

  if(f){
    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = malloc(length);
    if(buffer){
      fread(buffer, 1, length, f);
    }
    fclose(f);
  }
  return buffer;
}


float* random2Darray(int rows, int cols){
  /* Generate a random 2D array */

  int numElements = rows * cols;
  float* array = (float*) malloc(numElements * sizeof(float));

  int i, j, temp;
  // fill 1D array
  for(i = 0; i < numElements; i++){
    array[i] = i + 1;
  }

  // shuffle elements
  for(i = 0; i < numElements; i++){
    j = i + rand() / (RAND_MAX / (numElements - i) + 1);
    temp = array[j];
    array[j] = array[i];
    array[i] = temp;
  }

  return array;
}

float* zeros2Darray(int rows, int cols){
  /* Generate a 2D array of zeros */

  int numElements = rows * cols;
  float* zeros = (float*) malloc(numElements * sizeof(float));

  // fill with zeros
  for(int i = 0; i < numElements; i++){
    zeros[i] = 0.0;
  }

  return zeros;
}


void print2Darray(float* array, int rows, int cols){
  /* Print a 2D array to the console */
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      printf("%f ", array[cols * row + col]);
    }
    printf("\n");
  }
  printf("\n");
}


int allClose(float* A, float* B, int rows, int cols, float eps){
  /* Checks A and B elementwise for equality within eps */
  float a, b;
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      a = A[row * cols + col];
      b = B[row * cols + col];
      if(fabsf(a - b) >= eps){
        return 0;
      }
    }
  }
  return 1;
}
