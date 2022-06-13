char* getKernelSource();

float* random2Darray(int rows, int cols);

float* zeros2Darray(int rows, int cols);

void print2Darray(float* array, int rows, int cols);

int allClose(float* A, float* B, int rows, int cols, float eps);
