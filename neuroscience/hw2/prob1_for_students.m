%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main function for problem1. 
% Your task is to fill in a few lines in this function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load c2p3.mat
stim=double(stim);
window=12; %steps; each step corresponds to 15.6 ms 

%----------calculate the spike-triggered average --------
n=length(counts);
C=zeros(16,16,window); 
%
% PUT YOUR CODES HERE
%
% C(:,:,1) should corresponds to the stimulus at tau=11 time steps
% C(:,:,2) should corresponds to the stimulus at tau=10 time steps
%   ...
% C(:,:,12) should corresponds to the stimulus at tau=0
%
for j = 1:16
    for k = 1:16
            for tao = 0:window-1
                C(j, k, window - tao) = sum(counts(tao+1:end).*squeeze(stim(j,k, 1:end - tao)))/sum(counts(tao+1:end));
                
            end
    end
end
%%---------- plot the results ---------------
figure(1)
for i=1:window 
    subplot(3,4,i);
    %plot(squeeze(C(1,1,:)));
    imagesc(C(:,:,i));  
    colormap(gray)
    str = sprintf('tau=%d*15.6 ms',window-i); %plot in the reverse direction of time    
    title(str)
    axis off
end

%----- summing up the images across one spatial dimension -----
%
% PUT YOUR CODES HERE
% you may want to use the commands: mesh, contour, colorbar, etc
%
figure(2);
sigma_s2 = 10;
avgfr = mean(counts);
D_tao = C*avgfr/sigma_s2;
D_xt = squeeze(sum(D_tao,2));
contour(D_xt);
xlabel('x');
ylabel('t');
colorbar;
mesh(D_xt);
xlabel('x');
ylabel('t');
colorbar;

return
