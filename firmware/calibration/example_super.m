clear;clc;close all

%--------------------------------------------------------------------------
% load example data
load example_training_data.mat
whos

%--------------------------------------------------------------------------
tic
Super = fitrsuper(In_Train,Out_Train,In_Validation,Out_Validation,OutDescription);
toc
