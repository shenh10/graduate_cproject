%% Experiment with the cnn_mnist_fc_bnorm
[net_rl, info_rl] = mlp_mnist(...
  'expDir', 'data/mlp/mnist-relu','activation', 'relu');
[net_sm, info_sm] = mlp_mnist(...
  'expDir', 'data/mlp/mnist-sigmoid','activation','sigmoid');
figure(1) ; clf ;
subplot(1,2,1) ;
semilogy([info_rl.val.objective]', 'o-') ; hold all ;
semilogy([info_sm.val.objective]', '+-') ; 
xlabel('Training samples [x 10^3]'); ylabel('energy') ;
grid on ;
h=legend('ReLU','Sigmoid') ;
set(h,'color','none');
title('objective') ;
subplot(1,2,2) ;
plot([info_rl.val.top1err]', 'o-') ; hold all ;
plot([info_rl.val.top5err]', 'o--') ; 
plot([info_sm.val.top1err]', '+-') ; 
plot([info_sm.val.top5err]', '+--') ; 
h=legend('ReLU-val','ReLU-val-5','Sigmoid-val','Sigmoid-val-5') ;
grid on ;
xlabel('Training samples [x 10^3]'); ylabel('error') ;
set(h,'color','none') ;
title('error') ;
drawnow ;