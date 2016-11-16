#include <mex.h>

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  const mxArray *I = prhs[0];
  double *indata = mxGetPr(I);
  double *patchSize = mxGetPr(prhs[1]);
  const int *size = mxGetDimensions(I);
  int J = (int)patchSize[0], K = (int)patchSize[1], H = (int)patchSize[2];
  int M = size[0],           N = size[1],           P = size[2];

  int numPatches = (M - J + 1)*(N - K + 1)*(P - H + 1);
  int out_rows = J*K*H, out_cols = numPatches;
  mxArray *out = mxCreateDoubleMatrix( out_rows, out_cols, mxREAL );
  double *outdata = mxGetPr(out);

  int patch = 0;
  for( int h_offset = 0; h_offset < P-H+1; h_offset++ ){
    for( int k_offset = 0; k_offset < N-K+1; k_offset++ ){
      for( int j_offset = 0; j_offset < M-J+1; j_offset++ ){
        int row = 0;
        for( int h = 0; h < H; h++ ){
          for( int k = 0; k < K; k++ ){
            for( int j = 0; j < J; j++ ){
              outdata[patch*out_rows + row] = 
                indata[ (j_offset+j) + (k_offset+k)*M + (h_offset+h)*M*N ];
              ++row;
            }}}
      ++patch;
      }}}
  plhs[0] = out;
}