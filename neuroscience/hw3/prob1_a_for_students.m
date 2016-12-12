function Hopfield_network()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starter codes for problem1(a). 
% Your task is to fill in a few lines in this file as indicated.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = 13; % the number of patterns stored
N = 100; % the number of elements in a pattern
% generate patterns
S = ones(N,P); % each column corresponds to a pattern 
ind = rand(N,P)-0.5<0;
S(ind) = -1; 
% construct the weight matrix M
%
% PUT YOUR CODES HERE
%
M = - P * eye(N);
for i = 1:P
M = M + S(:,i)* S(:,i)';
end

steps = 500;

%--------- subproblem (a) ----------
% initialize  
% v0 = S(:,1);
% id = randperm(N);
% change_id = id(1:20);
% v0(change_id) = -v0(change_id);
% 
% % run the network
% q = hopfield(M,steps,v0,S(:,1));
% 
% % plot the results
% figure(1)
% plot(q)
% xlabel('iterations t')
% ylabel('q(t)')

% --- subproblem(b)---
minq = zeros(10,1);
for i = 1:10
for CN = 10:50
v0 = S(:,1);
id = randperm(N);
change_id = id(1:CN);
v0(change_id) = -v0(change_id);

% run the network
q = hopfield(M,steps,v0,S(:,1));
if q(end) ~= 1
    disp(sprintf('CN = %d, the inital q(0): %f, converge to q(end):%f',CN, q(1), q(end)));
    minq(i) = q(1);
    break
end
end
% plot the results
% figure(1)
% plot(q)
% xlabel('iterations t')
% ylabel('q(t)')
end
disp(sprintf('Final mean q(0): %f', mean(minq)));

return


function q = hopfield(M,steps,v0,s)
% return the trace of correlation coefficient between v(t) and S(:,1)
N = length(v0);
q = zeros(steps,1);
v = v0;
%
% PUT YOUR CODES HERE
%
h = zeros(length(v),1);
for i = 1:steps
q(i) = v'*s/N;
v = sign(h + M*v);
end
return