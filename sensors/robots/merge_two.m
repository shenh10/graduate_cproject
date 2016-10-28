function [ Cg, mu, theta, Cl, Cg1, Cg2 ] = merge_two( theta1, theta2, C1, C2, mu1, mu2 )
%MERGE_TWO Summary of this function goes here
%   Detailed explanation goes here

R1 = rotate(-theta1);
R2 = rotate(-theta2);
Cg1 = transpose(R1)*C1*R1;
Cg2 = transpose(R2)*C2*R2;

Cg = Cg1 - Cg1*inv(Cg1+Cg2)*Cg1;
mu = mu1 + Cg1*inv(Cg1+Cg2)*(mu2-mu1);
theta = 0.5*atan(2*Cg(1,2)/(Cg(1,1)-Cg(2,2)));
Cl = transpose(rotate(-theta))*Cg*rotate(-theta);

function R=rotate(theta)
R = [cos(theta), sin(theta);-sin(theta), cos(theta)];
end

end

