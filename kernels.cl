/* OpenCL GPU kernel file */

#define TILE_WIDTH 16

__kernel void square(__global float* input, __global float* output, const unsigned int count) {
  int i = get_global_id(0);
  printf("%d", i);
  if(i < count) { output[i] = input[i] * input[i]; }
}

__kernel void MatMulInefficient(__global float* A, __global float* B, __global float* C, const unsigned int width) {
  /* NaiveMatrix Multiplication kernel */

  int x = get_global_id(0);
  int y = get_global_id(1);

  if((x < width) && (y < width)){
    for(int w = 0; w < width; w++){
      C[y * width + x] += A[y * width + w] * B[w * width + x];
    }
  }
}


__kernel void MatMulNaive(__global float* A, __global float* B, __global float* C, const unsigned int width) {
  /* NaiveMatrix Multiplication kernel */
  // printf("Naive!\n");
  int x = get_global_id(0);
  int y = get_global_id(1);

  if((x < width) && (y < width)){
    float Cval = 0.0;
    for(int w = 0; w < width; w++){
      Cval += A[y * width + w] * B[w * width + x];
    }
    C[y * width + x] = Cval;
  }
}


__kernel void MatMulShared(const __global float* B,
                      const __global float* A,
                      __global float* C, const int width) {
    // printf("Shared\n");
    // Thread identifiers
    const int row = get_local_id(0); // Local row ID (max: TILE_WIDTH)
    const int col = get_local_id(1); // Local col ID (max: TILE_WIDTH)
    const int globalRow = TILE_WIDTH*get_group_id(0) + row; // Row ID of C (0..M)
    const int globalCol = TILE_WIDTH*get_group_id(1) + col; // Col ID of C (0..N)

    // Local memory to fit a tile of TILE_WIDTH * TILE_WIDTH elements of A and B
    __local float Asub[TILE_WIDTH][TILE_WIDTH];
    __local float Bsub[TILE_WIDTH][TILE_WIDTH];

    // Initialise the accumulation register
    float acc = 0.0f;

    // Loop over all tiles
    const int numTiles = width/TILE_WIDTH;
    for (int t=0; t<numTiles; t++) {

        // Load one tile of A and B into local memory
        const int tiledRow = TILE_WIDTH*t + row;
        const int tiledCol = TILE_WIDTH*t + col;
        Asub[col][row] = A[tiledCol*width + globalRow];
        Bsub[col][row] = B[globalCol*width + tiledRow];

        // Synchronise to make sure the tile is loaded
        barrier(CLK_LOCAL_MEM_FENCE);

        // Perform the computation for a single tile
        for (int k=0; k<TILE_WIDTH; k++) {
            acc += Asub[k][row] * Bsub[col][k];
        }

        // Synchronise before loading the next tile
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    // Store the final result in C
    C[globalCol*width + globalRow] = acc;
    // printf("%f\n", C[globalCol*width + globalRow]);
}
