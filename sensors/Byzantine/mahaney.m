function cur_pe  = mahaney( PEnum, Corr, Corr_delta, Fault, Fault_delta )
%MAHANEY 此处显示有关此函数的摘要
%   此处显示详细说明
% implement FCA

cur_pe = zeros(1,PEnum);
corr_num = length(Corr);
cur_pe(1:corr_num ) = Corr;
t = floor((PEnum - 1)/3);
eps = 0.0000000001;
abs_val = 2.75;
acc_ori = max(Corr - abs_val) ;
delta = 0.5;
iter = 0;
while 1
    flag =   0;
    cur_pe_last = cur_pe;
    for i = 1:PEnum
        if i == 1
        v = [ cur_pe_last(1:corr_num),  Fault(:, i)' ];
        else
            v = cur_pe_last;
        end
        % check acceptable values
        acc = [];
        idx = [];
        for j = 1: length(v)
            % check v[j] is acceptable
            count = 0;
            for k = 1: length(v)
                if abs(v(j) - v(k)) <= delta;
                    count = count + 1;
                end
            end
            if count >= PEnum - t 
                acc = [acc, v(j)];
            else
                idx = [idx, j];
            end
        end
        if length(acc) > 0
            ea = mean(acc);
            v(idx) = ea;
        end
        if abs(mean(v) - cur_pe_last(i)) > eps
            flag = 1;
        end
        cur_pe(i) = mean(v);
    
    end
    disp(cur_pe);
    fprintf('Precesion: %f \n',    max(cur_pe)-min(cur_pe));
    if flag == 0
          break
    end
    iter = iter + 1;
end
fprintf('Iteration num: %d\n', iter);
end

