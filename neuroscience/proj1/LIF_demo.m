clear
clc
close all

w = [0.1,0.2,0.3,0.4,0.5];
x = [4,5,6,7,8];
N = length(x);
b = -3;
y = w*x'+b;

dt = 0.001;
T = 10;
len = T/dt;
normepsp = 1;
epsp = gausswin(10);
epsp = epsp/sum(epsp)*normepsp/dt;

% poisson spike generator
inputSpike = rand(N,len);
inputSpike = double(inputSpike<dt*repmat(x',[1,len]));
%sum(inputs,2)'/T you can check this value, mean firing rate, should
%approximate x

% total input
input = zeros(size(inputSpike));
for i = 1:N
    input(i,:) = conv(inputSpike(i,:),epsp,'same')*w(i);
%     input(i,:) = inputSpike(i,:)*w(i);
end
totalinput = sum(input,1)+b*normepsp;
%  sum(totalinput)*dt/T %this value should approximate y*normepsp

V = zeros(len,1);
output = V;
thresh = -10;
reset = -60;
spike = 50;
tao = 0.01;
% R = 0.5;
R = (thresh-reset)*tao/normepsp;
c = R/tao*dt;

for i = 1:len
    if i ==1
        V(i) = totalinput(i)*c;
    else
        
        if i>1 && V(i-1)==spike
            V(i) =reset+totalinput(i)*c;
        else
            V(i) = V(i-1)+totalinput(i)*c;
        end
        if V(i)>=thresh
            output(i)=1;
            V(i)=spike;
        end
    end
end
sum(output)/T % the output firing rate should approximate y
