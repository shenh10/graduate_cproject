function [last_rect] = kernel_ot( image, target_q, m, last_rect)
y_old = [ last_rect(3)/2,last_rect(4)/2];
y_new = [0,0];
eps = 1;
bottom = 10^-7;
while 1
I_crop =imcrop(image,last_rect);
[q_cur, b_cur] = color_distro(I_crop, m, 1);
% step 1: Get first candidate from previous predicted bounding box
% evaluate correlation
correlation = sum(sum(sqrt(target_q.*q_cur)));
[row, col, channel] = size(I_crop);
% step 2: Derive weights
w = zeros(row,col);
for i = 1:row
    for j = 1:col
        tmp = zeros(channel,m);
        for k = 1:channel
            tmp(k,b_cur(i,j,k)) = 1;
        end
        w(i, j) = sum(sum(sqrt(target_q./q_cur).*tmp));
    end
end
y_new = [ sum(sum(w.* repmat([1:col],row,1)))/sum(sum(w)),sum(sum(w.* repmat([1:row]',1,col)))/sum(sum(w))];
disp(y_old);
disp(y_new);
rectangle('position',last_rect,'LineWidth',2,'EdgeColor','r');
last_rect = [ y_new(1) + last_rect(1) - last_rect(3)/2, y_new(2) + last_rect(2) - last_rect(4)/2, last_rect(3:end)];
disp(last_rect);
if norm(y_old-y_new) < eps
    break;
else
    y_old = y_new;
end
end
end

