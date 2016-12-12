clc;
clear all;
close all;
% a) Uniform Sampling

sample_n = [10, 100, 1000, 10000,100000];
max_iter = 50;
predict = zeros(length(sample_n), max_iter);
for iter = 1:max_iter
for i = 1:length(sample_n)
N = sample_n(i);
x = rand(N, 1);
fx = exp(-x) + 0.01*cos(100*x);  
predict(i,iter) = sum(fx)/N;
end
end
final_avg = mean(predict,2);
final_var = std(predict, [], 2);
disp('Uniform Sampling');
disp(final_avg);
disp(final_var);

% b) Use p(x) = A e^(-x);%pdf = (1-exp(-t))/(1-exp(-1));
A = exp(1)/(exp(1)-1);
predict = zeros(length(sample_n), max_iter);
for iter = 1:max_iter
for i = 1:length(sample_n)
N = sample_n(i);
x = rand(N,1);
x_p = -log( 1-(1-exp(-1))*x );
fxpx = (exp(-x_p) + 0.01*cos(100*x_p))./(A*exp(-x_p));
predict(i,iter) = sum(fxpx)/N;
end
end
final_avg = mean(predict,2);
final_var = std(predict, [], 2);
disp('Importance Sampling');
disp(final_avg);
disp(final_var);
