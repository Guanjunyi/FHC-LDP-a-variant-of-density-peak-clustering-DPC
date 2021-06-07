% Please kindly cite the paper Junyi Guan, Sheng li, Xiongxiong He, Jinhui Zhu, and Jiajia Chen 
%"Fast hierarchical clustering of local density peaks via an association degree transfer method," 
% Neurocomputing,2021,Doi:10.1016/j.neucom.2021.05.071

% The code was written by Junyi Guan in 2021.

clear all;close all;clc;
%% load dataset
load dataset/jain
data = jain;
answer = data(:,end);
data = data(:,1:end-1);
%% parameter setting
k = 9;
C = 2;
%% FHC_LPD clustering
[cl] = FHC_LPD(data,k,C);
%% evaluation
[AMI,ARI] = Evaluation(cl,answer);
%% show result
Result = struct;
Result.k = k;
Result.C = C;
Result.AMI = AMI;
Result.ARI = ARI;
Result