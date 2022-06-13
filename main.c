/* Optimizing Matrix Multiplication with OpenCL on Mac

Alex Angus

6/10/22
*/
#include <stdio.h>
#include <stdlib.h>
#include <OpenCL/opencl.h> // import OpenCL libraries
#include <string.h>
#include <time.h>

#include "utils.h"
#include "sequential.h"

#define WORKGROUP_SIZE 16
#define DIM 2048
#define EPS 1e-8
#define ITERATIONS 10

// structure to organize OpenCL setup
typedef struct {
  cl_context context;
  cl_command_queue commands;
  cl_program program;
  int SETUP_SUCESS;
} cl_setup;


cl_setup init(){

  cl_setup setup; // initialize setup struct

  // get kernel code
  const char* kernelSource = getKernelSource();

  cl_int err; // for CL error code reporting
  cl_event event = NULL; // CL event

  // Query the device ID
  cl_device_id device_id;
  clGetDeviceIDs(NULL, CL_DEVICE_TYPE_GPU, 1, &device_id, NULL);

  // create the OpenCL context: https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml/clCreateContext.html
  cl_context context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);

  // generate the command queue: https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml/clCreateCommandQueue.html
  cl_command_queue commands = clCreateCommandQueue(context, device_id, 0, &err);

  if(!commands){
    printf("Failed to create command queue.\n");
    setup.SETUP_SUCESS = EXIT_FAILURE;
    return setup;
  }

  // create and build the GPU program with source kernel code (string)
  cl_program program = clCreateProgramWithSource(context, 1, (const char **) &kernelSource, NULL, &err);

  if(!program){
    printf("Failed to create the program.\n");
    setup.SETUP_SUCESS = EXIT_FAILURE;
    return setup;
  }

  err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);

  if(err != CL_SUCCESS){
    size_t len;
    char buffer[2048];
    printf("Error: Failed to build program executable!\n");
    clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer),
    buffer, &len);

    printf("%s\n", buffer);
    exit(1);
  }

  setup.context = context;
  setup.commands = commands;
  setup.program = program;
  setup.SETUP_SUCESS = 1;

  return setup;
}

double queue_kernel(cl_setup setup, float* A, float* B, float* C, cl_kernel kernel){
  /* queue kernel function and return execution time */

  clock_t timer = clock(); // start timer
  cl_int err;
  cl_event event = NULL;

  // create input and output memory buffers.
  unsigned int mem_size = sizeof(float) * DIM * DIM;
  cl_mem A_d = clCreateBuffer(setup.context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, mem_size, A, &err);
  cl_mem B_d = clCreateBuffer(setup.context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, mem_size, B, &err);
  cl_mem C_d = clCreateBuffer(setup.context, CL_MEM_READ_WRITE, mem_size, NULL, &err);

  // check for successful memory allocation
  if(!A_d || !B_d || !C_d){
    printf("Memory allocation failed.\n");
    exit(1);
  }

  // set kernel arguments
  err = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&A_d);
  err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&B_d);
  err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&C_d);
  unsigned int width = DIM;
  err |= clSetKernelArg(kernel, 3, sizeof(int), (void *)&width);

  if(err != CL_SUCCESS){
    printf("Failed to set kernel arguments.\n");
    exit(1);
  }

  // enqueue a command to execute a kernel on a device
  size_t global[2] = {DIM, DIM}; // the global work size
  size_t local[2] = {WORKGROUP_SIZE, WORKGROUP_SIZE};
  int work_dim = 2; // The number of dimensions used to specify the global work-items and work-items in the work-group

  err = clEnqueueNDRangeKernel(setup.commands, kernel, work_dim, NULL, global, local, 0, NULL, &event);

  // block until OpenCL commands in the command queue are issued and completed
  clFinish(setup.commands);

  // transfer from device to host
  clEnqueueReadBuffer(setup.commands, C_d, CL_TRUE, 0, sizeof(float) * DIM * DIM, C, 0, NULL, NULL);

  timer = clock() - timer;

  // release buffers
  clReleaseMemObject(A_d);
  clReleaseMemObject(B_d);
  clReleaseMemObject(C_d);

  double time_s = ((double) timer) / CLOCKS_PER_SEC; // convert to seconds

  return time_s;
}


int main(){
  cl_setup setup = init();
  cl_int err;

  if(!setup.SETUP_SUCESS){
    printf("OpenCL setup failed.\n");
    exit(1);
  }
  else{
    printf("OpenCL setup complete!\n");
  }

  // define kernels
  cl_kernel inefficient = clCreateKernel(setup.program, "MatMulInefficient", &err);
  cl_kernel naive = clCreateKernel(setup.program, "MatMulNaive", &err);
  cl_kernel tiled = clCreateKernel(setup.program, "MatMulShared", &err);

  // check for sucessful kernel parsing
  if(err != 0){
    printf("Error in kernel.\n");
    exit(1);
  }

  // generate matrices
  float* A = random2Darray(DIM, DIM);
  float* B = random2Darray(DIM, DIM);

  clock_t sequential_time;

  // calculate Matrix multiplication sequentially as the "ground truth"
  float* C_sequential = zeros2Darray(DIM, DIM);

  sequential_time = clock();
  MatMulSequential(A, B, C_sequential, DIM, DIM, DIM);
  sequential_time = clock() - sequential_time;
  double total_sequential_time = ((double) sequential_time) / CLOCKS_PER_SEC;

  double total_inefficient_time = 0;
  double total_naive_time = 0;
  double total_tiled_time = 0;

  for(int iteration = 0; iteration < ITERATIONS; iteration++){
    float* C = zeros2Darray(DIM, DIM); // initialize output array

    // queue kernels
    total_inefficient_time += queue_kernel(setup, A, B, C, inefficient);

    int correct = allClose(C_sequential, C, DIM, DIM, EPS);


    if(!correct){
      printf("Inefficient Incorrect.\n");
      // print2Darray(C_sequential, DIM, DIM);
      // print2Darray(C, DIM, DIM);
      exit(1);
    }

    total_naive_time += queue_kernel(setup, A, B, C, naive);

    correct = allClose(C_sequential, C, DIM, DIM, EPS);

    if(!correct){
      printf("Naive Incorrect.\n");
      exit(1);
    }

    total_tiled_time += queue_kernel(setup, A, B, C, tiled);

    correct = allClose(C_sequential, C, DIM, DIM, EPS);

    if(!correct){
      printf("Tiled Incorrect.\n");
      // print2Darray(C_sequential, DIM, DIM);
      // print2Darray(C, DIM, DIM);
      exit(1);
    }

  }

  // get average times
  total_inefficient_time /= ITERATIONS;
  total_naive_time /= ITERATIONS;
  total_tiled_time /= ITERATIONS;

  // release setup
  clReleaseProgram(setup.program);
  clReleaseCommandQueue(setup.commands);
  clReleaseContext(setup.context);

  // release kernels
  clReleaseKernel(inefficient);
  clReleaseKernel(naive);
  clReleaseKernel(tiled);

  printf("Matrix dimensions: %d x %d\n", DIM, DIM);
  printf("Sequential time: %f ms \n", total_sequential_time * 1000);
  printf("Inefficient time: %f ms \n", total_inefficient_time * 1000);
  printf("Naive time: %f ms \n", total_naive_time * 1000);
  printf("Tiled time: %f ms \n", total_tiled_time * 1000);

  return 0;
}
