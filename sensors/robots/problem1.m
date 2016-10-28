function problem1()
close all;
clear;
% actual position
gt_x0 = [-1, 0];
dt = 0.1;
t = 16;
seq_len = t/dt + 1;
s_len = t/dt;
gt_theta0 = -30/180*2*pi;
gt_v0 = 0.5;
gt_v = gt_v0*ones(t/dt,1);
x_real = zeros(2,length(gt_v)+1);
x_real(:,1) = gt_x0;
for i = 1:t/dt
x_real(:,i+1) = gt_x0 + gt_v0*i*dt* [ cos(gt_theta0), sin(gt_theta0)];
end
%a) measure velocity only
% x0 = [7; -5; 0];
% P0 =  [100,0,0;0,100,0;0,0,100];
% sigma_v = 0.1;
% sigma_s = 0.01;
% v_noise = gt_v0*ones(s_len,1) + sigma_v*randn(s_len,1);
% % Generate velocity observation data
% phi = [1,0, cos(gt_theta0)*dt; 0, 1, sin(gt_theta0)*dt; 0,0,1];
% H = [0,0,1];
% w = sigma_s*randn(3,1);
% v_n = sigma_v*randn(1,1);
% Q = w*transpose(w);
% R = v_n*transpose(v_n);
% [x_vec,P] =  kalman_filter(x0, P0, transpose(v_noise), phi, H, Q, R, @(x) f0);
% figure;
% plot(x_vec(1,:), x_vec(2,:));
% hold on;
% plot(x_real(1,:), x_real(2,:));
% title('Velocity Measurement Only');
% disp('Velocity: Final P:');
% disp(P);
% % b) measure angle
% x0 = [7; -5; 0; 0];
% P0 =  [100,0,0,0;0,100,0,0;0,0,100,0;0,0,0,100];
% sigma_theta = 0.01;
% sigma_s = 0.01;
% noise_data = zeros(2, s_len);
% noise_data(1,:) = gt_v0*ones(s_len,1) ;
% noise_data(2,:) = gt_theta0*ones(s_len,1) + sigma_theta*randn(s_len,1) ;
% phi = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
% H = [0,0,1,0;0,0,0,1];
% w = sigma_s*randn(4,1);
% v_n = [0;sigma_theta*randn(1,1)];
% Q = w*transpose(w);
% R = v_n*transpose(v_n);
% [x_vec,P] =  kalman_filter(x0, P0, noise_data, phi, H, Q, R,@(x) f1(x));
% figure;
% plot(x_vec(1,:), x_vec(2,:));
% hold on;
% plot(x_real(1,:), x_real(2,:));
% title('Angle Measurement Only');
% disp('Angle: Final P:');
% disp(P);
% c) distance to wall
x0 = [7;-5;0;0];
sigma_sonic = 0.03;
sigma_s = 0.001;
P0 =  [100,0,0,0;0,100,0,0;0,0,100,0; 0,0,0,100];
gt_wall = zeros(s_len,1);
noise_data = zeros(3, s_len);
for i = 1:s_len
gt_wall(i) =  - gt_x0(2) - gt_v0*i*dt* sin(gt_theta0);
end
noise_data(1,:) = gt_wall + sigma_sonic*randn(s_len,1);
phi = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
H = [0,-1,0,0;0,0,1,0;0,0,0,1];
w = sigma_s*randn(4,1);
v_n = sigma_sonic*randn(1,1);
Q = w*transpose(w);
%non noise of velocity or angular error 
figure;
hold on;
sigma_max = 1;
step = 0.1;
l = (0:sigma_max/step)*step;
a = [];
M = [];
for i = 1:length(l)
    sigma_v = 0;
    sigma_theta = l(i);
        noise_data(2,:) = gt_v0*ones(s_len,1) + sigma_v* randn(s_len,1);
        noise_data(3,:) = gt_theta0*ones(s_len,1) + sigma_theta* randn(s_len,1);
        R = [v_n.^2,0,0;0,sigma_v.^2,0;0,sigma_theta.^2,0];
        [x_vec,P] = kalman_filter(x0, P0, noise_data, phi, H, Q, R, @(x) f2(x));
        a =[a; plot(x_vec(1,:), x_vec(2,:))];
        M =[M; {sprintf('sigma_theta-%.3f',sigma_theta)}];
        disp(sprintf('Sonic: Final P: sigma_theta-%.3f', sigma_theta));
        disp(P);
end
a=[a;plot(x_real(1,:), x_real(2,:))];
M=[M;{sprintf('groundtruth')}];
legend(a, M);
title('With Sonic Measurement ');


% d) beacon

gt_b = [3,0];
gt_bd = zeros(s_len,1);
noise_data = zeros(3, s_len);
sigma_sonic = 0.03;
sigma_s = 0.001;
for i = 1:s_len
gt_bd(i) =  2* sqrt( (gt_x0(1) + gt_v0*i*dt* cos(gt_theta0) - gt_b(1)).^2 + (gt_x0(2) + gt_v0*i*dt* sin(gt_theta0)- gt_b(2)).^2);
end
noise_data(1,:) = gt_bd + sigma_sonic*randn(s_len,1);
x0 = [-0.5; -1; 0.1; 0];
P0 =  [100,0,0,0;0,100,0,0;0,0,100,0; 0,0,0,100];
w = sigma_s*randn(4,1);
v_n = sigma_sonic*randn(1,1);
Q = w*transpose(w);

%non noise of velocity or angular error 
figure;
hold on;
sigma_max = 0.08;
step = 0.01;
l = (0:sigma_max/step)*step;
ab = [];
M = [];
for i = 1:length(l)
    sigma_v = l(i);
    sigma_theta = 0;
        noise_data(2,:) = gt_v0*ones(s_len,1) + sigma_v* randn(s_len,1);
        noise_data(3,:) = gt_theta0*ones(s_len,1) + sigma_theta* randn(s_len,1);
        R = [v_n.^2,0,0;0,sigma_v.^2,0;0,sigma_theta.^2,0];
        [x_vec,P] = EKF(x0, P0, noise_data, @(x) f(x),@(x) h(x), Q, R, @(x) f3(x));
        ab =[ab; plot(x_vec(1,:), x_vec(2,:))];
        M =[M; {sprintf('sigma_v-%.3f',sigma_v)}];
        disp(sprintf('Beacon: Final P: sigma_v-%.3f', sigma_v));
        disp(P);        %% 
end
ab=[ab;plot(x_real(1,:), x_real(2,:))];
M=[M;{sprintf('groundtruth')}];
legend(ab, M);
title('With Beacon Sonic Measurement ');


function ff = f0(~)
ff = 0;
end

function ff = f1(x)
ff = [ cos(x(4))*x(3)*dt; sin(x(4))*x(3)*dt; 0;0];
end

function ff = f2(x)
 ff = [ cos(x(4))*x(3)*dt; sin(x(4))*x(3)*dt; 0; 0];   
end
function [A,W,H,V] = f3(x)
xb = gt_b;
A = [1,0,cos(x(4))*dt, -x(3)*sin(x(4))*dt; 0, 1, sin(x(4))*dt, x(3)*cos(x(4))*dt;0,0,1,0;0,0,0,1];
a = sqrt((x(2)-xb(2)).^2 + (x(1) - xb(1)).^2);
W = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
H = [2*(x(1) - xb(1))/a, 2*(x(2) - xb(2))/a, 0,0; 0,0,1,0; 0,0,0,1];
V = eye(3);
end
function z = f(x)
z = zeros(length(x), 1);
z(1:end) = [x(1) + x(3)* cos(x(4))* dt; x(2) + x(3)*sin(x(4))*dt; x(3); x(4)];
end

function z = h(x)
xb = gt_b;
z = zeros(3, 1);  
z(1) = 2*sqrt((x(1) - xb(1)).^2 + (x(2) - xb(2)).^2);
z(2:end) = x(3:end);
end
end
