%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This partial program is designed for problem2.
% Your task is to fill in a few lines in this file as indicated.
% Batch mode training is used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
gaussian = 1; % 0: hard and square neighborhood; 
              % 1: gaussian neighborhood              
samplesize = 50000;
gridsz = 64; % Change it to 64 if your computer has a low memory!
zmax=56.32;
qmax=51.2;

% Sampling data
X = features(samplesize,qmax,zmax,gridsz)';

% run som
iterations=30;
eta=1; % eta should be <=1. 

W = single(init(qmax,gridsz)');

nd = neighbor_cyclic(gridsz,10,gaussian);
for itr = 1:iterations    
    fprintf('iteration #: %d\n',itr);
    if itr == round(iterations*0.25),     nd = neighbor_cyclic(gridsz,10,gaussian);
    elseif itr == round(iterations*0.50), nd = neighbor_cyclic(gridsz,8,gaussian); % shrinking the neighborhood
    elseif itr == round(iterations*0.75), nd = neighbor_cyclic(gridsz,6,gaussian); % shrinking the neighborhood
    end
        
    % Look for the best matching units
    %
    % Hint: define 'labels' as a samplesize long row vector with each
    % element being the index of the BMU for each input sample
    %
    % PUT YOUR CODES HERE
    %
    % neighborhood neurons also activated
    labels = zeros(1,samplesize);
    [N, lenW] = size(W);
    for i = 1:samplesize
        [v,labels(i)] = min(sum((W - repmat(X(:,i),1, lenW)).^2));   
    end
    S=nd(:,labels);
    
    % Calculate weighted sum of inputs, denoted by dW
    %
    % HINT: define 'counts' here which will appear in the denominator (see slide: batch mode training).
    %
    % PUT YOUR CODES HERE
    %
    % update W
    counts = sum(S');
    dW = X*S'./repmat(counts, 5,1);
    W = (1-eta)*W+eta*dW; % for eta=1, the rule becomes the same as in the slides

    % just zap empty centroids so they don't introduce NaNs everywhere.
    badIndex = find(counts == 0);
    if ~isnan(badIndex)
        warning('some neurons have not been assigned any inputs!')
    end
    W(:,badIndex) = zeros(size(W,1),length(badIndex),'single'); 
   
    % plot results
    if mod(itr,1)==0
        phi2 = atan2(W(4,:),W(3,:));
        idx=phi2<0;
        phi2(idx)=phi2(idx)+2*pi;
        phi=phi2/2  *180/pi;
        
        % orientation map
        figure(1);
        imagesc(reshape(phi,gridsz,gridsz)');
        axis square, colormap jet;  colorbar
        
        % occular dominance map
        figure(2);
        imagesc(reshape(W(5,:),gridsz,gridsz)');
        axis square, colormap jet;  colorbar;
        
        % superimpose occular dominance map on the orientation map
        figure(3)
        contour(flipud(reshape(phi,gridsz,gridsz)'),16,'b');
        hold on
        contour(flipud(reshape(W(5,:),gridsz,gridsz)'),[0,0],'k','LineWidth',2);
        axis square
        hold off
        
        pause(0.001)
    end
    
end

