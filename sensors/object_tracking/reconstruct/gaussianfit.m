function R = gaussianfit(x, y , center)
[nsample, dim] = size(x);
R = rand(dim,dim);
param = reshape(R, dim*dim, 1);
param = lsqnonlin(@(p) myfun(p, x, y, center),param);
R = reshape(param,2,2);
plot_surf(param,x,y, center);

    function F = myfun(param, x, z, center)
        F = 0;
        for i = 1: length(z)
            pred = gaussian_param(param, x(i,:),center);
            disp(sprintf('expected: z:%f, pred:%f', z(i), pred));
            F = F + (z(i) - pred )^2;
        end
    end
    function v = gaussian_param(param, x, center)
        r11=param(1);
        r12=param(2);
        r22=param(3);
        d=param(4);
        a=r11^2;
        b=r11*r12;
        c=r12^2+r22^2; 
        v = gaussian(a,b,c,d,x,center);
    end
    function plot_surf(param,x,y, center)
        for i = 1:center(1)*2
            for j = 1:center(2)*2
                z(i,j) = gaussian_param(param, [i,j], center);
            end
        end
        surf(z);
        hold on;
        scatter3(x(:,2),x(:,1),y,'r');
    end
    function F = gaussian(a,b,c,d,x,center)
        F = d*exp(-(a*(x(1)-center(1))^2+2*b*(x(1)-center(1))*(x(2)-center(2))+c*(x(2)-center(2))^2));
    end
end

