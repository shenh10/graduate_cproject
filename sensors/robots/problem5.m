function problem5()
%PROBLEM5 Summary of this function goes here
%   Detailed explanation goes here
x0 = 3; P0 = 100;
A = 5*ones(1,10);
B = 4*ones(1,1000);
C = 2*ones(1,5000);
phi = 1;
H = 1;
Q = 0;
sigma_es = 5;
R = sigma_es.^2;
[xa_vec,Pa] =  kalman_filter(x0, P0, A, phi, H, Q, R, @(x) f(x));
[xb_vec,Pb] =  kalman_filter(x0, P0, B, phi, H, Q, R, @(x) f(x));
[xc_vec,Pc] =  kalman_filter(x0, P0, C, phi, H, Q, R, @(x) f(x));

figure;
plot(1:length(xa_vec), xa_vec);
hold on;
plot(1:length(xb_vec), xb_vec);
plot(1:length(xc_vec), xc_vec);
axis([0,5000, 0,5.1]);
disp('Final P:');
disp(Pa);
disp(Pb);
disp(Pc);

function z = f(~)
    z = 0;
end

end

