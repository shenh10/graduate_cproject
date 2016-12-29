function [Y,U] = pca(X,K)
% Input: 
%   X: matrix with image patches as columns 
%   K: the number of largest magnitude eigenvalues
% Output: 
%   Y: transformed data. Each column is a data point
%   U: eigenvector matrix. Each column is an eigenvector 
[patch_size,N] = size(X);
C = zeros(patch_size);
for i = 1:N
    C = C + X(:,i)*X(:,i)';
end
C = 1./N*C;
[V,D] = eig(C);
U = V(:, end-K+1:end);
Y = U'*X;
