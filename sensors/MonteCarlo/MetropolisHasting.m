clear all;
close all;
clc;
sigma = 5;
N = 1000;
samples = zeros(N,1);
P = @(x) exp(-x.^2).*(2+sin(5*x)+sin(2*x));

for i = 2:N
    
x = sigma*randn+samples(i-1);
A = min(1, P(x)/P(samples(i-1)));
u = rand();
samples(i) = samples(i-1)*double(u > A) + x*double(u<=A);
end
xx = [-3:0.01:2.99]';
y = P(xx);
syms x
area = int(P,x, 0, 1);
area = double(vpa(area,5));
y = y./area;
figure;
plot(xx, y);
hold on;
scatter(samples, zeros(N,1));
drawnow;