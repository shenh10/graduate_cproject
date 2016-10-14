function [list, ids, range ] = sensorfusion( PEnum, Corr, Corr_delta, Fault, Fault_delta )
%SENSORFUSION 此处显示有关此函数的摘要
%   此处显示详细说明

corr_num = length(Corr);
t = floor((PEnum - 1)/3);
list = {};
ids = {};
range = {};
for i = 1:PEnum
    v = [ Corr(1:corr_num),  Fault(:, i)' ];
    v_delta = [Corr_delta(1:corr_num), Fault_delta(:, i)'];
    % PE receive these values in v
    points = [];
    counts = [];
    tmplist = [];
    tmpid = [];
    for j = 1: PEnum
    % for each delta range of PEs
        mmax = v(j) + v_delta(j);
        mmin = v(j) - v_delta(j);
        minC = 0;
        maxC = 0;
        for k = 1: PEnum
            if v(k) - v_delta(k) <= mmin && v(k) + v_delta(k) >= mmin
                minC = minC + 1;
            end
            if v(k) - v_delta(k) <= mmax && v(k) + v_delta(k) >= mmax
                maxC = maxC + 1;
            end
        end
            if minC >= PEnum - t
                points = [points, mmin];
                counts = [counts, minC];
            end
            if maxC >= PEnum - t
                points = [points, mmax];
                counts = [counts, maxC];
            end
     end
     
     [B, id_ori] = sort(points);
     j  = 1;
     while j <= length(points) - 1
         tmplist = [tmplist; B(j), B(j+1)];
         tmpid = [tmpid; min(counts(id_ori(j)), counts(id_ori(j+1)))];
         if j + 2 <= length(points) && counts(id_ori(j+2)) ~= counts(id_ori(j))
             j = j + 1;
         else
             j = j + 2;
         end
     end
     list{i} = tmplist;
     ids{i} = tmpid;
     range{i} = [ B(1), B(end) ]; 
end


