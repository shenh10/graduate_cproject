function [x_vec,P] =  EKF(x0, P0, Y, f_state, h_obs, Q, R, ff)
% x(t+1) = phi * x(t) + wt + f
% y(t) = H * x(t) + v(t)
% Q = E(w(t)*w(t).T)
% R = E(v(t)*v(t).T)
P = P0;
x = x0;
[vec_len, sample_len] = size(Y);
x_vec = zeros(length(x), sample_len + 1);
x_vec(:,1) = x;
for i = 1: length(Y)
[A,W, H, V] = ff(x);
xba = f_state(x);
Pba = A* P * transpose(A) + W*Q*transpose(W);
K = Pba * transpose(H) * inv(H*Pba*transpose(H) + V*R*transpose(V));
P = ( eye(size(K*H)) - K * H )* Pba;
if vec_len == 1
x = xba + K*(Y(i)-h_obs(xba));
else
x = xba + K*(Y(:,i)-h_obs(xba));
end
x_vec(:, i+1) = x;
end
end
