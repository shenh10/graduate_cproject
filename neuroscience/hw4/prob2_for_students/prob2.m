addpath('../')

% set data directory
dataset_dir = '../data';
patchsize= 21;
samplesize = 10000;

% sample image patches
fprintf('Sampling data\n')
X=sampleimages(samplesize,patchsize,dataset_dir);
% 2.1
[patch, samplesize] = size(X);
center_l = round((patch+1)/2);
center = X(center_l, :);
corr_m = corr(center', X');
corr_m = reshape(corr_m, patchsize,patchsize);
imagesc(corr_m);
colorbar;

%2.2
K = 100;
[Y, U] = pca(X,K);
random_d  = floor(rand()* (K-1))+1;
corr_m = corr( Y(random_d,: )',Y');
bar(corr_m);