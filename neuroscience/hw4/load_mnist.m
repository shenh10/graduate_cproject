function [X,Y] = load_mnist()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This partial program is designed for problem3.
% You need to train an SOM using 10000 28-by-28 images from the MNIST
% dataset 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------- data preparation ---------------
dataDir = fullfile('mnist') ;
imdbFile = fullfile(dataDir,'imdb.mat');
if ~exist(dataDir,'dir'), mkdir(dataDir); end
if exist(imdbFile, 'file')
  imdb = load(imdbFile) ;
else
  imdb = getMnistImdb(dataDir) ;
  save(imdbFile, '-struct', 'imdb') ;
end
imdb.images.data = squeeze(imdb.images.data); % Now imdb.images.data become 28*28*70000 and 
samplesize = 10000;
X = reshape(imdb.images.data(:,:,1:samplesize),28^2,samplesize);
X = double(X); %S*X' does not supported single type of X since S is sparse
Y = imdb.images.labels(1:samplesize);


% --------------------------------------------------------------------
function imdb = getMnistImdb(dataDir)
% --------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
% This function is from MatConvNet
files = {'train-images-idx3-ubyte', ...
         'train-labels-idx1-ubyte', ...
         't10k-images-idx3-ubyte', ...
         't10k-labels-idx1-ubyte'} ;

if ~exist(dataDir, 'dir')
  mkdir(dataDir) ;
end

for i=1:4
  if ~exist(fullfile(dataDir, files{i}), 'file')
    url = sprintf('http://yann.lecun.com/exdb/mnist/%s.gz',files{i}) ;
    fprintf('downloading %s\n', url) ;
    gunzip(url, dataDir) ;
  end
end

f=fopen(fullfile(dataDir, 'train-images-idx3-ubyte'),'r') ;
x1=fread(f,inf,'uint8');
fclose(f) ;
x1=permute(reshape(x1(17:end),28,28,60e3),[2 1 3]) ;

f=fopen(fullfile(dataDir, 't10k-images-idx3-ubyte'),'r') ;
x2=fread(f,inf,'uint8');
fclose(f) ;
x2=permute(reshape(x2(17:end),28,28,10e3),[2 1 3]) ;

f=fopen(fullfile(dataDir, 'train-labels-idx1-ubyte'),'r') ;
y1=fread(f,inf,'uint8');
fclose(f) ;
y1=double(y1(9:end)')+1 ;

f=fopen(fullfile(dataDir, 't10k-labels-idx1-ubyte'),'r') ;
y2=fread(f,inf,'uint8');
fclose(f) ;
y2=double(y2(9:end)')+1 ;

set = [ones(1,numel(y1)) 3*ones(1,numel(y2))];
data = single(reshape(cat(3, x1, x2),28,28,1,[]));
dataMean = mean(data(:,:,:,set == 1), 4);
data = bsxfun(@minus, data, dataMean) ;

imdb.images.data = data ;
imdb.images.data_mean = dataMean;
imdb.images.labels = cat(2, y1, y2) ;
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),0:9,'uniformoutput',false) ;
