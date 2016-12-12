function [ output_args ] = hmm( )
var_n = 3;
ob_n = 2;
trans = [0.8,0.2,0; 0.1,0.7,0.2; 0.9, 0, 0.1];
emission = [0.1,0.9;0.5,0.5; 0.9, 0.1];
N = 10000;
%1.1
[ seq, obs ] = generate_seq(N, trans, emission, 1);
arg = 3;
if arg == 1
% BW
tic;
[ init_state,trans_init,emission_init ] = initial(var_n,ob_n, 1 );
[emission_est, trans_est] = BW( obs, var_n, ob_n ,init_state, trans_init, emission_init, false);
duration = toc;
disp(sprintf('Eclapse time: %f s',duration));
disp(emission_est);
disp(trans_est);
% % b) 
state_est = viterbi(obs, emission_est, trans_est, var_n, ob_n);
acc = sum(state_est == seq)/N;
disp(sprintf('accuracy of viterbi estimation: %f', acc));
end
% %[seq,states] = hmmgenerate(1000,trans,emission);
% 
if arg == 3
%c) benchmark the variance
iter = 100;

t_set = zeros(var_n^2,iter);
e_set = zeros(var_n*ob_n,iter);
for i = 1:iter
disp(sprintf('iteration %d', i));
[ init_state,trans_init,emission_init ] = initial(var_n,ob_n, 1 );
[emission_est, trans_est] = BW( obs, var_n, ob_n ,init_state, trans_init, emission_init, false);
t_set(:, i) = reshape(trans_est, 1, var_n^2);
e_set(:, i) = reshape(emission_est, 1, var_n*ob_n);
end

ave_trans_est = mean(t_set,2);
ave_trans_est = reshape(ave_trans_est,var_n,var_n);

ave_emission_est = mean(e_set,2);
ave_emission_est = reshape(ave_emission_est,var_n,ob_n);
var_trans_est = reshape(var(t_set,0,2), var_n, var_n);
var_emission_est = reshape(var(e_set,0,2), var_n, ob_n);
state_est = viterbi(obs, ave_emission_est, ave_trans_est, var_n, ob_n);
acc = sum(state_est == seq)/N;
disp(sprintf('accuracy of viterbi estimation: %f', acc));
disp('mean of transtion matrix:');
disp(ave_trans_est);
disp('mean of emission matrix:');
disp(ave_emission_est);

disp('variance of transtion matrix:');
disp(var_trans_est);
disp('variance of emission matrix:');
disp(var_emission_est);

end
if arg == 2
% % b) 
state_est = viterbi(obs, emission, trans, var_n, ob_n);
acc = sum(state_est == seq)/N;
disp(sprintf('accuracy of viterbi estimation: %f', acc));
end

if arg == 4
% Gibbs Sampling
tic;
var_n = 3;
ob_n = 2;
[ init_state,trans_init,emission_init ] = initial(var_n,ob_n, 1 );
[ trans_est, emission_est] = gibbs( obs, var_n, ob_n ,init_state, trans_init, emission_init, @(p) gc(p));
duration = toc;
disp(sprintf('Eclapse time: %f s',duration));
disp(trans_est);
disp(emission_est);
state_est = viterbi(obs, emission_est, trans_est, var_n, ob_n);
acc = sum(state_est == seq)/N;
disp(sprintf('accuracy of viterbi estimation: %f', acc));
end


function [ seq, obs ] = generate_seq(N, trans, emission, init)
    seq = [init];
    obs = [gc(emission(init,:))];
    for ii = 2:N
        seq = [seq, gc(trans(seq(ii-1),:))];
        obs = [obs, gc(emission(seq(ii-1),:))];
    end
end


function cur = gc(p)
    cur = 1;
    c = rand(1);
    acc = 0;
    for i = 1: length(p)
        if c < p(i) + acc
            cur = i;
            break;
        else
            acc = acc + p(i);
        end
    end
end

end

