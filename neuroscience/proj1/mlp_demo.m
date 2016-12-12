clear
clc
close all
%% prepare data
N_train = 1000;
N_test = 100;
train_X = single(rand(1,1,2,N_train)); 
train_Y = squeeze(single(train_X(:,:,2,:)>train_X(:,:,1,:)))'+1;

test_X = single(rand(1,1,2,N_test));
test_Y = squeeze(single(test_X(:,:,2,:)>test_X(:,:,1,:))+1)';

plot(squeeze(train_X(1,1,1,train_Y==1)),squeeze(train_X(1,1,2,train_Y==1)),'o')
hold on
plot(squeeze(train_X(1,1,1,train_Y==2)),squeeze(train_X(1,1,2,train_Y==2)),'x')
%% training parameter
lr = 0.001;
alpha=0.01;

%% network design
net.layers{1} = struct(...
    'name', 'conv1', ...
    'type', 'conv', ...
    'weights', {{0.05*randn(1,1,2,4,'single'), 0.05*randn(4,1,'single')}}, ...
    'pad', 0, ...
    'stride', 1) ;
net.layers{end+1} = struct(...
    'name', 'relu1', ...
    'type', 'relu') ;

net.layers{end+1} = struct(...
    'name', 'conv2', ...
    'type', 'conv', ...
    'weights', {{0.01*randn(1,1,4,2,'single'), 0.05*randn(2,1,'single')}}, ...
    'pad', 0, ...
    'stride', 1) ;
net.layers{end+1} = struct('type', 'loss','class',train_Y);
net = vl_simplenn_tidy(net); % necessary end

% training
for i_epoch = 1:1000
    % assign X and Y to network
       net.layers{end}.class=train_Y; 
    res = vl_simplenn(net, train_X,1); %res contains all backprop information, including loss, gradient
    % get the accuracy of this batch
    answ = squeeze(res(end-1).x);
    [argvalue, ansid] = max(answ);
    acc = mean(ansid==train_Y);
    
    % update parameters using sgd, scan all layers, update weight according
    % to back prop information
    for  i_lay = 1:length(net.layers)
        layer = net.layers{i_lay};
        try n_w=length(layer.weights);
        catch  continue
        end
        if isempty(res(i_lay).dzdw)||n_w==0
            continue
        end
        for i_w=1:n_w
            w = layer.weights{i_w};% get w
            grad = res(i_lay).dzdw{i_w}; % get gradient
            w = w-lr*grad-alpha*lr*w; % updade 
            net.layers{i_lay}.weights{i_w} = w; % assign back
        end
    end
        net.layers{end}.class=test_Y;
        res = vl_simplenn(net, test_X,1); %res contains all backprop information, including loss, gradient
    answ = squeeze(res(end-1).x);
    [argvalue, ansid] = max(answ);
    acc = mean(ansid==test_Y);

    disp( sprintf( 'Epoch %d,  Acc %.4f, Loss %.4f', i_epoch,acc,res(end).x/N_train ) )
    
end
