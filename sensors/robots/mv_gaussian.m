function [ output_args ] = mv_gaussian( x1, x2, mu, Sigma )
%MV_GAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
mu = mu';
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
surfc(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');

end

