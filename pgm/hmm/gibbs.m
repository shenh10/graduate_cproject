function [ trans, emission ] = gibbs(  obs, var_n, ob_n ,init_state, trans_init, emission_init, gc )
%GIBBS Summary of this function goes here
%   Detailed explanation goes here
y = [];
T = length(obs);
for i = 1:T
    y = [y,gc(init_state)];
end
iter = 1;

eps = 10^-5;
M = 100;
N = 10000;
verbose = 1;
trans_error = 1;
em_error = 1;
trans = trans_init;
emission = emission_init;
while iter <= M && (trans_error >= eps || em_error >= eps)
it = 1;
if verbose
    disp(sprintf('iteration %d, trans_error %f, em_error %f', iter, trans_error, em_error));
end
lastP = trans;
lastQ = emission;
lasty = y;
lasterr = zeros(N,1);
while it <= N

for i = 2:T-1
    p = [];
    for j = 1:var_n
        p = [ p, trans(j, y(i+1))*emission(j,obs(i))*trans(y(i-1),j)];
    end
    p = p / sum(p);
    y(i) = gc(p);
end
% after burn in period 
if it >= N/2
    y_pre = y;
for i = 1:var_n
    for j = 1:var_n
        trans(i,j) = sum( (y_pre(1:end-1) == i ).* (y(2:end) == j) )/(T-1);
    end
    trans(i,:) = trans(i,:)./sum(trans(i,:));
end
for i = 1:var_n
    for j = 1:ob_n
        emission(i,j) = sum( (y == i ).* (obs == j) )/T;
    end
    emission(i,:) = emission(i,:)./sum(emission(i,:));
end

end
lasterr(it) = sum(abs(lasty - y));
lasty = y;

if verbose && mod(it, 10) == 0
    disp(sprintf('Sample %d th round, last error %f', it, lasterr(it)));
end

it = it + 1;
end

trans_error = sum(sum(abs(trans-lastP)));
em_error = sum(sum(abs(emission-lastQ)));
iter = iter + 1;
disp(trans);
disp(emission);
end

end

