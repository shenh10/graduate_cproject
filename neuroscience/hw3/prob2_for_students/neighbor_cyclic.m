function nd=neighbor_cyclic(gridsz,ndsize,gaussian)
% 1. Each colum of nd represent the gaussian neighborhood of a neuron on the
% gridsz-by-gridsz grid. This long column is made by concartenate the columns of the
% gridsz-by-gridsz grid. 
% 2. The order of the long columns of nd corresponds to the neurons swapped from
% top-down and left-right on the gridsz-by-gridsz grid. 

th=0.1; % the minimum value of the neighborhood. (The max is 1.) 
         % For ndsize =1, the diameter of the neighborhood is about 1
         %     ndsize =2,                                           3
         %     ndsize =3,                                           3
         %     ndsize =4,                                           5
         %     ndsize =5,                                           5
         %     ndsize =6,                                           7
         %     ndsize =7,                                           7
         %     ndsize =10,                                          11
         %     ndsize =20,                                          21
if gaussian
    sigma = sqrt(-(0.5*ndsize)^2/2/log(th));
    
    % describe the square neighborhood
    r = floor(sqrt(-2*sigma^2*log(th))); % radius
    D =2*r+1;
    [Ncol,Nrow] = meshgrid(1:D);
    diff = [Nrow(:),Ncol(:)]-repmat([r+1,r+1],[D^2 1]);
    d = sum(diff.^2,2);
    Nvec = exp(-d/2/sigma^2);
    
    % Optional: construct circular neighborhood
    idx = d>-2*sigma^2*log(th);
    Nvec(idx) = 0;
    
    % neighborhood matrix
    N = reshape(Nvec,D,D);
else
    N = ones(ndsize);
    D = ndsize;
    r = floor(D/2);
end
    
temp=zeros(gridsz);
temp(1:D,1:D)=N;

nd=repmat(zeros(1),[gridsz^2,gridsz^2]);

n=0;
for i = -r:gridsz-r-1
    for j = -r:gridsz-r-1
         n = n + 1; 
         curr_rf = circshift(temp,[j,i]);
         nd(:,n) = curr_rf(:);
         % manually check the correctness (pls comment it out!)
         %neighbor_mat = reshape(nd(:,n),gridsz,gridsz);
    end
end

nd=sparse(nd);

