function [ emission, trans ] = BW( obs, var_n, ob_n ,init_state, trans_init, emission_init, verbose)
%Baum-Welch algorithm
T = length(obs);
alpha = zeros(T, var_n);
beta = zeros(T, var_n);
scale_alpha = zeros(T, 1);
scale_beta = zeros(T, 1);

trans_error = 1;
em_error = 1;
eps = 10^-8;
max_iter = 500;
trans = trans_init;
emission = emission_init;
iter = 0;
while iter < max_iter 
if (trans_error < eps) && (em_error < eps)
    break
end
if verbose
disp(sprintf('iteration %d, trans_error %f, em_error %f', iter, trans_error, em_error));
end
lastP = trans;
lastQ = emission;
alpha(1,:) = init_state.*emission(:, obs(1));
scale_alpha(1) = sum(alpha(1,:));
alpha(1,:) = alpha(1,:) / scale_alpha(1);
beta(T,:) = ones(var_n,1)';

%beta(T,:) = [1,0,0]';

scale_beta(T) = sum(beta(T,:));
beta(T,:) = beta(T,:)/scale_beta(T);
for t = 1:T-1
    alpha(t+1,:) = (alpha(t, :)*trans).*emission(:, obs(t+1))';
    scale_alpha(t+1) = sum( alpha(t+1,:));
    alpha(t+1,:) =  alpha(t+1,:)/scale_alpha(t+1);
    beta(T-t,:) = (trans*(emission(:, obs(T+1-t)).*beta(T+1-t,:)'));
    scale_beta(T-t) = sum( beta(T-t,:));
    beta(T-t,:) = beta(T-t,:)/scale_beta(T-t) ;
end
p1 = log(sum(alpha(T,:))) + sum(log(scale_alpha));
p2 = sum(log(scale_beta)) + log(sum(init_state.*emission(:,obs(1)).*beta(1,:)'));
%p1  = sum(alpha(T,:))*prod(scale_alpha);
%p2 = sum(init_state.*emission(:,obs(1)).*beta(1,:)')*prod(scale_beta);
%p1 = sum(alpha(T,:));
%p2 = sum(init_state.*emission(:,obs(1)).*beta(1,:)');
%disp(sprintf('p1:%f,p2:%f', p1, p2));
% error = abs(p -lastp);
xi = zeros(T-1, var_n, var_n);
ka = zeros(T, var_n);

for t = 2:T
        z = alpha(t-1,:)*trans*(emission(:, obs(t)).*beta(t,:)');
        for i = 1:var_n
            for j = 1:var_n
                xi(t-1, i, j) =  alpha(t-1,i)*trans(i,j)*emission(j, obs(t))*beta(t,j);
            end
        end

    xi(t-1,:,:) = xi(t-1,:,:) / z;
end
for t = 1:T
ka(t,:) = alpha(t,:).*beta(t,:)/(alpha(t,:)*beta(t,:)');
end
%ka = sum(xi, 3)
trans = squeeze(sum(xi, 1))./repmat(squeeze(sum(ka(1:T-1,:),1))',1,var_n);
for i = 1:ob_n
emission(:,i) = (obs == i)*ka./squeeze(sum(ka,1));
end
%disp(trans);
trans_error = sum(sum(abs(trans-lastP)));
em_error = sum(sum(abs(emission-lastQ)));
iter = iter + 1;
end
end

