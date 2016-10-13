function  cur_pe  = hybrid( PEnum, Corr,Corr_delta, Fault, Fault_delta )
%DOLEV 此处显示有关此函数的摘要
%   此处显示详细说明
cur_pe = zeros(1,PEnum);
corr_num = length(Corr);
t = floor((PEnum - 1)/3);
eps = 0.001;
while 1
    for i = 1:PEnum
        v = sort([ Corr(1:corr_num),  Fault(:, i)' ]);
        [list, ids, range ] = sensorfusion( PEnum, Corr, Corr_delta, Fault, Fault_delta );
        segs = list(i);
        segs = segs{1};
        segids = ids(i);
        segids = segids{1};
        fprintf('most accurate answer for PE %d: [ %f, %f ]\n', i, segs(1,1), segs(end, 2));
        avg = 0;
        for j = 1: length(segs)
           avg = avg + segids(j)*mean(segs(j,:));
        end
        avg = avg / sum(segids);
        cur_pe(i) = avg;
    end
    disp(cur_pe);
    if abs(max(cur_pe) - min(cur_pe)) < eps
        break
    end
end

