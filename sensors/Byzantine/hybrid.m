function  cur_pe  = hybrid( PEnum, Corr,Corr_delta, Fault, Fault_delta )
%DOLEV 此处显示有关此函数的摘要
%   此处显示详细说明
cur_pe = zeros(1,PEnum);
corr_num = length(Corr);
cur_pe(1:corr_num ) = Corr;
t = floor((PEnum - 1)/3);
eps = 0.001;
iter  = 0;
while 1
    flag =   0;
    cur_pe_last = cur_pe;
    for i = 1:PEnum
        if iter == 0
        [list, ids, range ] = sensorfusion( PEnum, cur_pe_last(1:corr_num ), Corr_delta, Fault, Fault_delta );
        else
            f = repmat(cur_pe_last(corr_num + 1:end)', 1, PEnum);
            rc = [];
            for k = 1:PEnum
                rc = [rc, (range{k}(2) - range{k}(1))/2];
            end
           rf = repmat(rc(corr_num+1:end)', 1, PEnum);
           [list, ids, range ] = sensorfusion( PEnum, cur_pe_last(1:corr_num ), rc(1:corr_num) , f, rf );
        end
        segs = list(i);
        segs = segs{1};
        segids = ids(i);
        segids = segids{1};
        fprintf('most accurate answer for PE %d: [ %f, %f ]\n', i, segs(1,1), segs(end, 2));
        avg = 0;
        [len,~] = size(segs);
        for j = 1: len
           avg = avg + segids(j)*mean(segs(j,:));
        end
        avg = avg / sum(segids);
        if abs(avg - cur_pe_last(i)) > eps
            flag = 1;
        end
        cur_pe(i) = avg;
    end
    disp(cur_pe);
    fprintf('Precesion: %f \n',   max(cur_pe)-min(cur_pe));
    if flag == 0
          break
    end
    iter = iter +  1;
end
fprintf('Iteration num: %d\n', iter);
end
