%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starter codes for problem3.
% You need to first complete whiten.m, then complete this file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set data directory
dataset_dir = '../data';

addpath('../')

patchsize= 20;
numbases = 100;
samplesize = 50000;
num_iters = 2000;
convergencecriterion=1e-4;  % for ICA

% sample image patches
fprintf('Sampling data\n')
X=sampleimages(samplesize,patchsize,dataset_dir);

% PCA whitening
fprintf('Removing DC component\n')
X=bsxfun(@minus, X, mean(X));
fprintf('Whitening data\n');
[Z,V]=whiten(X,numbases);

% ICA
fprintf('Starting complete ICA\n')
W=ica(Z,numbases,convergencecriterion,num_iters);

% transform back to original space from whitened space
Wica = W*V;

% Compute A using pseudoinverse (inverting canonical preprocessing is tricky)
Aica=pinv(Wica);

figure(1);
display_network(Aica,10,10);
figure(2);
display_network(Wica',10,10);

% linear responses of the filters on all patches
s=Wica*X;
corr_m = corr(s');
corr_m = corr_m - eye(length(corr_m));
[f,c] = hist(corr_m, 100);

f = f/sum(sum(f));
figure(1);
bar(c,f,10);

corr_m = corr((s.^2)');

corr_m = corr_m - eye(length(corr_m));
[f,c] = hist(corr_m, 100);

f = f/sum(sum(f));
figure(2);
bar(c,f,10);


