function [ output_args ] = problem4()
%PROBLEM4 Summary of this function goes here
%   Detailed explanation goes here
% estimate average height

N = 1000;
average_gt = 1.70;
sigma_gt = 0.1;
sigma_es = 0.00001;
sample_data = average_gt + sigma_gt*randn(1,N);
x0 = 1.2;
P0 = 100;
phi = 1;
H = 1;
Q = 0;
R = sigma_es.^2;
[x_vec,P] =  kalman_filter(x0, P0, sample_data, phi, H, Q, R, @(x) f(x));
figure;
plot(1:length(x_vec), x_vec);
hold on;
plot(1:length(x_vec), average_gt* ones(length(x_vec)));
axis([0, 1000, 1.65, 1.8]);
title(sprintf('sigma_v = %f',sigma_es));
xlabel('samples');
ylabel('height(m)');
disp('Final P:');
disp(P);

function z = f(~)
    z = 0;
end
end

