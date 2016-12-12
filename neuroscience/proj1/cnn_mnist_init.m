function net = cnn_mnist_init(varargin)
% CNN_MNIST_LENET Initialize a CNN similar for MNIST
opts.batchNormalization = false ;
opts.networkType = 'simplenn' ;
opts.dropout = false ;
opts.once = true;

opts = vl_argparse(opts, varargin) ;

rng('default');
rng(0) ;

f=1/100 ;
net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(5,5,1,64, 'single'), zeros(1, 64, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type','relu');
net.layers{end+1} = struct('type', 'pool', ...
                           'method', 'max', ...
                           'pool', [4 4], ...
                           'stride', 4, ...
                           'pad', 0) ;
net.layers{end+1} = struct('type', 'conv', ...
   'weights', {{f*randn(6,6,64,10, 'single'), zeros(1,10,'single')}}, ...
   'stride', 1, ...
   'pad', 0) ;
net.layers{end+1} = struct('type', 'softmaxloss') ;

% optionally switch to batch normalization
if opts.batchNormalization 
        net = insertBnorm(net, 1) ;
end
if opts.dropout 
        net = insertDropout(net, 1) ;
end

% Meta parameters
net.meta.inputSize = [28 28 1] ;
net.meta.trainOpts.learningRate = 0.0001 ;
net.meta.trainOpts.numEpochs = 30 ;
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
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
               'learningRate', [1 1 0.05], ...
               'weightDecay', [1 1]) ;
%net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;

% --------------------------------------------------------------------
function net = insertDropout(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
layer = struct('type', 'dropout', ...
               'rate', 0.5) ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;
