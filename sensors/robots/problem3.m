function problem3()
%PROBLEM3 Summary of this function goes here
%  Detailed explanation goes here
%a) estimate integration I =  \int_0^pi cos(x)dx = 1
n = [10, 100, 1000, 10000, 30000];
disp('n, rect(upper), rect(lower), trapezoid, simpson');
for i = 1:length(n) 
dt = (pi/2)/n(i);
t = (0:n(i)-1)*dt;
thalf = (0.5:n(i)-0.5)*dt;
tplus = (1:n(i))*dt;
rect_upper = sum(dt* cos(t));
rect_lower = sum(dt* cos(tplus));
trapezoid = sum(dt*(cos(t)+cos(tplus))/2);
simpson = dt/6* sum(cos(t) + 4* cos(thalf) + cos(tplus));
str = sprintf('%d, %f, %f, %f, %f \n',...
    n(i), abs(1-rect_upper), abs(1-rect_lower), abs(1-trapezoid), abs(1-simpson));
disp(str);
end

% b) h = 0.5, 0.1,0.05, 0.025, 0.01
h = [0.5, 0.1, 0.05, 0.025, 0.01];
gt = pi/2;
for i =1:length(h)
    step = h(i);
    int = 0;
    for x = -1:step:1-step
        for y = -sqrt(1-x.^2):step:sqrt(1-x.^2)
            int = int + step.^2 * f(x,y);
        end
    end
% estimate in one axis
    x = -1:step:1-step;
    int2 = sum(step*fy(x));
    disp(sprintf('integration of f(x,y): step length %f, area estimate error is %f, line estimate error is %f\n',step, abs(int-gt), abs(int2-gt)));

end

function z = f(x, y)
  z = x.^2 + 6* x* y + y.^2;  
end
function z = fy(x)
  z = 4/3*x.^2.*sqrt(1-x.^2) + 2/3*sqrt(1-x.^2);
end
end

% syms x y
% z = x.^2 + 6* x* y + y.^2;  
% y1 = -sqrt(1-x.^2);
% y2 = sqrt(1-x.^2);
% x1 = -1; x2 = 1;
% a = int(int(z, y, y1, y2), x, x1, x2);
% vpa(a,5)
% 
