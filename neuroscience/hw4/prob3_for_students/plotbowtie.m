function plot_bowtie(L1,L2,grid)
%plot the bowtie
%   L1 and L2 should be column vectors
a1=min(L1); b1=max(L1);
bin1=(b1-a1)/grid;
a2=min(L2); b2=max(L2);
bin2=(b2-a2)/grid;
S=zeros(grid+1);
for i=1:length(L1)
        ind1=round((L2(i)-a2)/bin2)+1;
        ind2=round((L1(i)-a1)/bin1)+1;
        S(ind1,ind2)=S(ind1,ind2)+1;
end
% transform to image coordinate
S=S(size(S,1):-1:1,:);
for j=1:size(S,2)
    a=min(S(:,j)); b=max(S(:,j));
    if b-a>1
        S(:,j)=(S(:,j)-a)/(b-a);
    end
end

imagesc(S);