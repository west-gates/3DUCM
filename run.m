close all; clear all; clc;

addpath('lib');
addpath(genpath('pnm'));

mkdir('grad');
mkdir('temp');
mkdir('results');
mkdir('blockfile');

%gradient operator scales
scales=[2,4,6];



datapath='Chen_ppm/';
foldernames={'ice20'};

%foldernames={'ibsr_1','ibsr_2','ibsr_3','ibsr_4','ibsr_5','ibsr_6','ibsr_7','ibsr_8','ibsr_9','ibsr_10','ibsr_11','ibsr_12','ibsr_13','ibsr_14','ibsr_15','ibsr_16','ibsr_17','ibsr_18'};



tic

for i = 1:1
	%filepath=[datapath,foldernames{i}];
	%videoGradient(filepath,scales,i);
	%max_grad(scales,i);
	%affinity_block(i);
	%L_eigs(i);
	%spb(i);
	foldername=foldernames{i};
	PathInput=[datapath,foldername];
	gbh_merge(i,foldername,PathInput);
	PathInput=['level0/',foldernames{i}];
    	generating_frames(i,PathInput,foldernames);
end
toc
