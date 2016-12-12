function HH_model()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main function for problem2(a). 
% Your task is to fill in a few lines in the function odefun()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here we use the buildin function of MATLAB for simulating an ODE
% function. You can also use the Eular method as in Problem 3.
I_e = 0.2;
[t, x] = ode23(@(t,x) odefun(t,x,I_e),[0 100],[-65 0.3177 0.0529 0.5961]);
figure(1);
subplot(4,1,1)
plot(t, x(:,1)); 
ylabel('V (mV)')
subplot(4,1,2)
plot(t,x(:,2));
ylabel('n')
subplot(4,1,3)
plot(t,x(:,3));
ylabel('m')
subplot(4,1,4)
plot(t,x(:,4));
ylabel('h')
xlabel('t (ms)')
curve = firing_rate([0 1000],[-65 0.3177 0.0529 0.5961]);
figure;
plot(curve);
title('Ie/A-Spike');
xlabel('Ie/A(uA/mm2)');
ylabel('r(spikes/s)');


function curve = firing_rate(t0, x0)
thresholdV = 0;
I_e = 0:0.002:0.5;
curve = zeros(size(I_e));
for i = 1:length(I_e)
    [t, x] = ode23(@(t,x) odefun(t,x,I_e(i)),t0,x0);
    curve(i) = sum((x(1:end-1,1)< thresholdV).*( x(2:end,1)> thresholdV));
end
end

function xdot=odefun(t,x,I_e)
g_L=0.003;
g_K=0.36;
g_Na=1.2;
E_L=-54.387;
E_K=-77;
E_Na=50;
V = x(1);
n = x(2);
m = x(3);
h = x(4);
c_m = 10; %nF/mm^2

i_m = g_L*(V-E_L) + g_K*n^4*(V-E_K) + g_Na*m^3*h*(V-E_Na);
Vdot = (-i_m+I_e)/c_m*1e3; %1e3 is for consistency of units

% calculate dn/dt 
alpha_n = 0.01*(V+55)/( 1-exp(-0.1*(V+55)) );
beta_n = 0.125*exp( -0.0125*(V+65) );
ndot = alpha_n*(1-n)-beta_n*n;

% calculate dm/dt 
alpha_m = 0.1*(V+40)/( 1-exp(-0.1*(V+40)) );
beta_m = 4*exp( -0.0556*(V+65) );
mdot = alpha_m*(1-m)-beta_m*m;

% calculate dh/dt 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PUT YOUR CODE HERE
%
alpha_h = 0.07*exp(-0.05*(V+65));
beta_h = 1/(1+exp(-0.1*(V+35)));
hdot = alpha_h*(1-h)-beta_h*h;

xdot=[Vdot; ndot; mdot; hdot];
end
end

