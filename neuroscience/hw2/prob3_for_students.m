function LIF_model()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main function for problem3. 
% Your task is to fill in a few lines in this function as well as
% the function LIF()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E_L = -70; %mV
Rm = 10;% M Ohm
tau_m = 10; %ms
V_reset = -80; %mV
V_th = -54;% mV
spike = 0; % mV; spike voltage

T = 500; % ms; total simulation time
dt = 0.1; % ms
V0 = V_reset;

%------------ subproblem (a) --------------------
% do leaky integrate-and-fire simulation
Ie = 3; %nA. Please try other two values: 1.4 and 3 and see the difference
[V,rate] = LIF(E_L, Rm, Ie, tau_m, V_reset, V_th, V0, spike,T, dt);

figure(1)
plot(0:dt:T, V);
fprintf('Firing rate is %4.1f Hz when Ie= %5.2f nA \n', rate,Ie);


xlabel('t(ms)');
ylabel('V(mV)');

title(sprintf('Ie = %f nA', Ie));
axis([0, 500, V_reset - 10, spike + 10]);

%-------------- subproblem (b) --------------------
Ie_max = 5; %nA
stepsize = 0.01; %nA
Ie = 0:stepsize:Ie_max; % nA
steps = length(Ie);
f = zeros(2, steps);
for i=1:steps
    % simulation
    [~,rate] = LIF(E_L, Rm, Ie(i), tau_m, V_reset, V_th, V0, spike,T, dt);
    f(1,i) = rate;
    if Rm*Ie(i) > V_th - E_L
        f(2,i) = 1/(10^-3*tau_m * log( (Rm * Ie(i) + E_L - V_reset)/(Rm * Ie(i) + E_L - V_th)));
    end
    % prediction
    % Calculate f(2,i) using the equation specified in the problem
    % description
    % PUT YOUR CODES HERE
    % 
    
end
figure(2)
plot(Ie, f)
legend('Simulation', 'Prediction');
xlabel('Ie(nA)');
ylabel('firing rate(Hz)');
set(legend, 'position', [0.15, 0.5, 0.3, 0.15]);
return

function [V, rate] = LIF(E_L, Rm, Ie, tau_m, V_reset, V_th, V0, spike,T, dt)
% return the voltage trace V in mV and firing rate in Hz  
% Hint: You can either use 
% 1. the method described in Appendix A of Chapter 5 of
%    Dayan and Abbott (2001), Theoretical Neuroscience; or 
% 2. the following general Eular method. 
%    Suppose we want to simulate the ordinary differential equation dv/dt =
%    f(v). Note dv = f(v)dt, then 
%    v(t+dt)-v(dt) = f(v)dt or v(t+dt) = f(v)dt + v(dt)
%

Tm_inv = dt / tau_m;
steps = T/dt;
pulse = zeros(steps,1);
pulse(100/dt+1:400/dt) = Ie; % note that the current is applied only between 100~400 ms
V = zeros(1, steps + 1);
V(1) = V0;
%
% PUT YOUR CODES HERE
%
delta = 2;
for i = 2:steps
I_e = pulse(i);
%[t, x] = ode23(@(t,x) odefun(t,x, [E_L, Rm, tau_m, I_e]),[1:delta],[V(i-1)]);
V(i) = V(i-1)+ dt/tau_m*(-V(i-1) + E_L + Rm* I_e);
%V(i) = x(end,1);
if V(i) >= V_th
    V(i-1) = spike;
    V(i) = V_reset;
end
end
rate = sum(V==spike)/(300/1000);
return


function X_dot = odefun(t,x, args)
E_L = args(1); %mV
Rm = args(2);% M Ohm
tau_m = args(3); %ms
I_e = args(4);c
V = x(1);
V_dot = 1/tau_m*(-V + E_L + Rm* I_e);
X_dot = [V_dot];
return
