function [Y,V] = whiten(X,K)
% Input: 
%   X: matrix with image patches as columns 
%   K: the number of largest magnitude eigenvalues
% Output: 
%   Y: transformed data. Each column is a data point
%   V: whitening matrix satisfying Y=V*X

[patch_size,N] = size(X);
C = zeros(patch_size);
for i = 1:N
    C = C + X(:,i)*X(:,i)';
end
C = 1./N*C;
[V,D] = eig(C);
U = V(:, end-K+1:end);
D = D(end-K+1:end, end-K+1:end);

V = inv(D).^(0.5)*U';
Y = V*X;