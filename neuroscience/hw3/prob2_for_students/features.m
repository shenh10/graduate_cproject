function X = features(samplesize,qmax,zmax,gridsz)
% bounds for [x,y,phi,q, z]
% Note that the first two dimensions are not used in this demo. 
L=[0 0 0  0 -zmax];
U=[gridsz gridsz pi qmax zmax];
X = repmat(L,[samplesize 1])+repmat(U-L,[samplesize 1]).*rand(samplesize,5);
phi = X(:,3);
q = X(:,4);
X(:,3)=q.*sin(2*phi);
X(:,4)=q.*cos(2*phi);