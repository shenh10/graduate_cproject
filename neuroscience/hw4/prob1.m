clc;
clear all;
close all;

%1.a)
K = 30;
M = 28;
N = 28;
[X,L] = load_mnist();
% [Y, U] = pca(X,K);
% display_network(U', M, N);

%1.b)
K = 2;
[Y, U] = pca(X,K);
gscatter(Y(1,:), Y(2,:), L,'ymcrgbwkkmr','o+*xsd^vph');