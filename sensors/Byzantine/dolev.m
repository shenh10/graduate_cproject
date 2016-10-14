function  cur_pe  = dolev( PEnum, Corr, Fault )
%DOLEV 此处显示有关此函数的摘要
%   此处显示详细说明
cur_pe = zeros(1,PEnum);
corr_num = length(Corr);
cur_pe(1:corr_num ) = Corr;
t = floor((PEnum - 1)/3);
eps = 10^(-10);
iter = 0;
while 1
    flag =   0;
    cur_pe_last = cur_pe;
    for i = 1:PEnum
        v = sort([ cur_pe_last(1:corr_num),  Fault(:, i)' ]);
        v = v(1+ t:end-t);
        newv = mean(v);
        if abs(newv - cur_pe(i)) > eps
            flag = 1;
        end
        cur_pe(i) = newv;
    end
    disp(cur_pe);
    fprintf('Accuracy: %f, Precesion: %f \n',    max(Corr) - min(Corr), max(cur_pe)-min(cur_pe));
    if flag == 0
          break
    end
    iter = iter +  1;
end
fprintf('Iteration num: %d\n', iter);
end

