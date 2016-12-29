function X = sampleimages(samples, winsize,datadir)
% INPUT variables:
% samples            total number of patches to take
% winsize            patch width in pixels
% datadir            directory of the data
%
% OUTPUT variables:
% X                  the image patches as column vectors

% list all image files in the folder
filelist=dir( fullfile(datadir,'*.tiff') );
filelist = [filelist;dir( fullfile(datadir,'*.jpg') )];

% Number of images
dataNum = length(filelist);
getsample = round(samples/dataNum);
samples = getsample * dataNum;

% Initialize the matrix to hold the patches
X = zeros(winsize^2,samples);

sampleNum = 1;
for i=(1:dataNum)
    
    % Load the image.
    I = imread(fullfile(datadir,filelist(i).name));
    
    % Transform to double precision
    I = double(I);
        
    % Normalize to zero mean and unit variance (optional)
    I = I-mean(I(:));
    I = I/sqrt(mean(I(:).^2));
    
    % Sample patches in random locations
    sizex = size(I,2);
    sizey = size(I,1);
    posx = floor(rand(1,getsample)*(sizex-winsize-1))+1;
    posy = floor(rand(1,getsample)*(sizey-winsize-1))+1;
    for j=1:getsample
        X(:,sampleNum) = reshape( I(posy(1,j):posy(1,j)+winsize-1, ...
            posx(1,j):posx(1,j)+winsize-1),[winsize^2 1]);
        sampleNum=sampleNum+1;
    end
end




