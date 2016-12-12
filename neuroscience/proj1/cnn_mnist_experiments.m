%% Experiment with the cnn_mnist_fc_bnorm
[net_fc, info_fc] = cnn_mnist(...
  'expDir', 'data/cnn2/mnist-baseline');

[net_bn, info_bn] = cnn_mnist(...
  'expDir', 'data/cnn2/mnist-bnorm', 'batchNormalization', true);

[net_do, info_do] = cnn_mnist(...
  'expDir', 'data/cnn2/mnist-dropout',  'dropout', true);


figure(1) ; clf ;
subplot(1,2,1) ;
semilogy([info_fc.val.objective]', 'o-') ; hold all ;
semilogy([info_bn.val.objective]', '+-') ;
semilogy([info_do.val.objective]', '*-') ;
%semilogy([info_bn_1.val.objective]', 's-') ;
%semilogy([info_do_1.val.objective]', '.-') ;
xlabel('Training samples [x 10^3]'); ylabel('energy') ;
grid on ;
%h=legend('BSLN', 'BNORM', 'DROPOUT','BNORM-once','DROPOUT-once') ;
h=legend('BSLN', 'BNORM', 'DROPOUT');
set(h,'color','none');
title('objective') ;
subplot(1,2,2) ;
plot([info_fc.val.top1err]', 'o-') ; hold all ;
plot([info_bn.val.top1err]', '+-') ;
plot([info_do.val.top1err]', '*-') ;
plot([info_fc.val.top5err]', 'o--') ; 
plot([info_bn.val.top5err]', '+--') ;
plot([info_do.val.top5err]', '*--') ;
h=legend('BSLN-val','BNORM-val','DROPOUT-val','BSLN-val-5','BNORM-val-5','DROPOUT-val-5') ;
grid on ;
xlabel('Training samples [x 10^3]'); ylabel('error') ;
set(h,'color','none') ;
title('error') ;
drawnow ;