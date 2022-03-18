close all; clear all;

%% Data

opts = detectImportOptions('final boost keep it safe.txt');
preview('final boost keep it safe.txt',opts)

%%

opts.DataLines = [200000 210000];
M = readmatrix('final boost keep it safe.txt', opts);

%%

data_1 = M(:,1);
data_2 = M(:,2);
data_3  = M(:,3);
data_4 = M(:,4);
data_5  = M(:,5);
data_5 = M(:,6);