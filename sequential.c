/* Sequential (CPU) version of matrix multiplication for comparison.

Alex Angus

6/10/22
*/

#include <stdio.h>
#include <stdlib.h>

void MatMulSequential(float* A, float* B, float* C, int width, int rowsA, int colsB){
  /* CPU Matrix Multiplication */
  for(int rowA = 0; rowA < rowsA; rowA++){
    for(int colB = 0; colB < colsB; colB++){
      float sum = 0.0;
      for(int w = 0; w < width; w++){
        sum += A[rowA * width + w] * B[w * width + colB];
      }
      C[rowA * colsB + colB] = sum;
    }
  }
}
