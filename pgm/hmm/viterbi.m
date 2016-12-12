function state = viterbi(obs, emission, trans, var_n, obs_n);
%VITERBI Summary of this function goes here
%   Detailed explanation goes here
T = length(obs);
viterbim = zeros(T, var_n);
bpointer = zeros(T, var_n);


viterbim(1,:) = trans(1,:)'.* emission(:, obs(1));
bpointer(1,:) = 0;
viterbim(1,:) = viterbim(1,:)/ sum(viterbim(1,:));
for t = 1:T-1
    for s = 1:var_n
        [viterbim(t+1,s), bpointer(t+1, s)] = max(viterbim(t, :).* trans(:, s)'.*emission(:, obs(t+1))');
    end
    viterbim(t+1, :) = viterbim(t+1,:)/sum(viterbim(t+1,:));
end
[v, I] = max(viterbim(T, :));

% backtrace
state = [I];
iter = I;
for t = T:-1:2
      iter = bpointer(t,iter);
      state =  [iter, state];
end
end

