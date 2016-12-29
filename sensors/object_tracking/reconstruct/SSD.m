function R  = SSD(I, rect, init_rect)
% init_rect = ceil(init_rect);
% rect = ceil(rect);
% target distribution
T = imcrop(I, init_rect);

T = mat2gray(T);

[row,col,~] = size(T);
npoints = 3;
dim = 2;
p = zeros(npoints,dim);
p(1,:) = [ floor( (row + 1)/ 2 ), floor((col + 1)/2) ];
p(2,:) = [ floor( (row + 1)/ 2 ), floor( (col + 1)/ 4 )];
p(3,:) = [ floor( (row + 1)/ 4 ), floor( (col + 1)/ 2 )];
% SSD



ssd = zeros(row,col);

for i = 1:row
    for j = 1:col
        this_rect = [ rect(1)+j - 1, rect(2)+i - 1 , init_rect(3:4)];
        this_T = imcrop(I, this_rect);
        this_T = mat2gray(this_T);
        [new_row, new_col, ~] = size(this_T);
        i_row = min(row, new_row);
        i_col = min(col, new_col);
        ssd(i,j) = sum(sum(sum((this_T(1:i_row,1:i_col,:) - T(1:i_row,1:i_col,:)).^2)));
    end
end
k = 0.1;
A = 0.01;
eps = 0.1;
step = 1;
while abs(summ(A,k,ssd)-1) > eps
    if summ(A,k,ssd) > 1
        step = min(1,step) * 3;
        k = k*step;
    end
    if summ(A,k,ssd) < 1
        step = max(step,1) * 0.5;
        k = k*step;
    end
end
fprintf('k: %f, sum: %f',k, A*sum(sum(exp(-k*ssd))));
ssd = zeros(npoints,1);
for i = 1:npoints
    this_rect = [ p(i,:), init_rect(3:4)];
    this_T = imcrop(I, this_rect);
    this_T = mat2gray(this_T);
    ssd(i) = sum(sum(sum((this_T - T).^2)));
end
rd = exp(-k*ssd);
R = gaussianfit( p, rd, p(1,:) );

function a= summ(A,k,ssd)
   a =  A*sum(sum(exp(-k*ssd)));
end
end


