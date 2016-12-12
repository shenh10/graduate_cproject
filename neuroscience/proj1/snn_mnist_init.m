function net = mlp_mnist_init(varargin)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST
opts.batchNormalization = false ;
opts.networkType = 'simplenn' ;
opts.activation = 'relu' ;

opts = vl_argparse(opts, varargin) ;

rng('default');
rng(0) ;

f=1/50 ;
l1 = 30;
l2 = 50;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(28,28,1,l1, 'single'),[]}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type','relu');
% net.layers{end+1} = struct('type', 'conv', ...
%    'weights', {{f*randn(1,1,l1,l2, 'single'),[]}}, ...
%    'stride', 1, ...
%    'pad', 0) ;
% net.layers{end+1} = struct('type','relu');
net.layers{end+1} = struct('type', 'conv', ...
   'weights', {{f*randn(1,1,l1,10, 'single'),[]}}, ...
   'stride', 1, ...
   'pad', 0) ;
net.layers{end+1} = struct('type','relu');
net.layers{end+1} = struct('type', 'softmaxloss') ;

% optionally switch to batch normalization

%net = insertReLU(net, 1,opts.activation) ;
%net = insertReLU(net, 3,opts.activation) ;

% Meta parameters
net.meta.inputSize = [28 28 1] ;
%net.meta.trainOpts.learningRate = 0.00001 ;
net.meta.trainOpts.learningRate = 0.0005 ;
net.meta.trainOpts.numEpochs =  30;
net.meta.trainOpts.batchSize = 128 ;

% Fill in defaul values
net = vl_simplenn_tidy(net) ;

% Switch to DagNN if requested
switch lower(opts.networkType)
  case 'simplenn'
    % done
  case 'dagnn'
    net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;
    net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), ...
      {'prediction', 'label'}, 'error') ;
    net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', ...
      'opts', {'topk', 5}), {'prediction', 'label'}, 'top5err') ;
  otherwise
    assert(false) ;
end


% --------------------------------------------------------------------
function net = insertReLU(net, l, activation)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
assert((strcmp(activation,'relu') == 1 || strcmp(activation,'sigmoid') == 1) );
layer = struct('type', activation) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
