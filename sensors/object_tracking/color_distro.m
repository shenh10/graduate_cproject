function  [q, b] = color_distro(image, m, h)
% m: number of bins

[row, col, channel] = size(image);

%Get histValues for each channel
v_max = 256;
v_min = 10^-6;
q = zeros(channel,m);
b = zeros(row, col, channel);
for i = 1:channel
b(:,:,i) = floor(double(image(:,:,i))/(v_max/m))+1;
end
for i = 1:row
    for j = 1:col
        dist = ((i - (row+1)/2)/row/h).^2 + ((j - (col+1)/2)/col/h).^2;
        for k = 1:channel
            q(k, b(i,j,k)) = q(k, b(i,j,k)) + kernel(dist);
        end
    end
end
q(q==0) = v_min;
q = q ./repmat( sum(q,2), 1,m);


function kx = kernel(x)
  d = 2;
  cd = 1;
  kx = 0.5* 1/cd*(d+2)*(1-x)*double(x <= 1);
end
end

