# 3DUCM

This is the experimental code for paper:


Chengliang Yang, Manu Sethi, Anand Rangarajan, and Sanjay Ranka, Supervoxel-based Segmentation of 3D Volumetric Images, in Proc. of ACCV, Taipei, Taiwan, ROC, 2016

This is a rough implementation of the ideas in the paper that has dissatisfactory efficiency. We are working on a higher performance version in C++.

# Step 1

In matlab, go to the lib folder, compile mex files with the command below:

mex -O CFLAGS="\$CFLAGS -std=c99 -Wall" im3col.c

# Step 2

Execute run.m to get the finest level of segmentation.
