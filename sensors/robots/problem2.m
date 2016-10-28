function problem2()
%PROBLEM2 Summary of this function goes here
%   Detailed explanation goes here
% b) 
close all;
clear all;
theta1 = 30/180*pi;
theta2 = 60/180*pi;
C1 = [9,0; 0, 1];
C2 = [16,0; 0, 0.81];
%% 
mu1 = [10.866;10.5];
mu2 = [10.5;10.866];
x1 = 5:0.2:20;
x2 = 5:0.2:20;
[ Cg, mu, theta, Cl, Cg1, Cg2 ] = merge_two( theta1, theta2, C1, C2, mu1, mu2 )
% figure;
% mv_gaussian( x1, x2, mu1, Cg1 );
% title('Observation Robot1');
% figure;
% mv_gaussian( x1, x2, mu2, Cg2 );
% title('Observation Robot2');
% figure;
% mv_gaussian( x1, x2, mu1, Cg1 );
% hold on;
% mv_gaussian( x1, x2, mu2, Cg2 );
% hold off;
% title('Observation Robot 1 and 2');

% figure;
% mv_gaussian( x1, x2, mu, Cg );
% title('Merged Observation');

% c) 
N = 10;

theta_in = rand(N,1)*pi;
target = [ -1,1;-1,0;-0.7,0;-0.5,0;-0.3,-0.3;0,-0.6;0,-1.2;0.5,-1.3;1,-1.4 ];
[s_len, ~] = size(target);
Cin = rand(N,2);
disp(Cin);
sigma = 0.1*rand(N,1);
Cg = zeros(s_len, 2,2);
mu = zeros(s_len, 2);
muin = zeros( N , s_len, 2);

for i = 1:N
muin(i,:,:) = target + sigma(i)*randn(s_len,2);
end
for i = 1:s_len
    theta_t = theta_in(1);
    C_t = diag(Cin(1,:));
    muin_t = squeeze(muin(1, i, :));
    for j = 1:N
        Cur = diag(Cin(j,:));
        [ Cg12, muin_t, theta12, C_t, Cg1, Cg2 ] = merge_two( theta_t, theta_in(j), C_t, Cur, muin_t, squeeze(muin(j,i,:)));
    end
    mu(i, :) = muin_t;
    disp(C_t);
end
M = [];
figure;
hold on;
for i = 1:N
plot(muin(i,:,1), muin(i,:,2),'g*');
M = [M, {sprintf('robot-%d',i)}];
end
% plot(mu2(:,1), mu2(:,2),'r*');
% plot(mu3(:,1), mu3(:,2),'g*');
plot(mu(:,1), mu(:,2),'rs');
M = [M, {'merged'}];
plot(target(:,1),target(:,2),'ko');
M = [M,{'groundtruth'}];
legend(M);
title('Observation Robots');

end

