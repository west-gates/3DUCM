# 3DUCM

This is the experimental code for paper:


Chengliang Yang, Manu Sethi, Anand Rangarajan, and Sanjay Ranka, Supervoxel-based Segmentation of 3D Volumetric Images, in Proc. of ACCV, Taipei, Taiwan, ROC, 2016

This is a rough implementation of the ideas in the paper that has dissatisfactory efficiency. We are working on a higher performance version in C++.

# Step 1

In matlab, go to the lib folder, compile mex files with the command below:

mex -O CFLAGS="\$CFLAGS -std=c99 -Wall" im3col.c

# Step 2

Execute run.m to get the finest level of segmentation. This step may take a while.

# Step 3

Go to the gbh folder, use the makefile to compile the code for the agglomeration step. This implementation is based on [LIBSVX](http://web.eecs.umich.edu/~jjcorso/r/supervoxels/).

# Step 4

Execute the compiled program to get the final results using the command below, run_gbh.sh gives an example:

./gbh c c_reg min sigma hie_num input output finest_level_input

finest_level_input is the output of Step 2. Specifications of other parameters please refer to [LIBSVX](http://web.eecs.umich.edu/~jjcorso/r/supervoxels/).



