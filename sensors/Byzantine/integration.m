clear ;
close all;
file = 'data2.txt';
fd = fopen(file, 'r');
tline= textread(file);
PEnum = tline(1, 1);
fault_num = tline(2, 1);
corr_num = PEnum - fault_num;
Corr= zeros(1, corr_num);
Corr_delta= zeros(1, corr_num);
Fault = zeros(fault_num, PEnum);
Fault_delta =  zeros(fault_num, PEnum);
i = 1;
while i <= PEnum
     if i <= corr_num
        Corr(i) = tline(i+2, 1); 
        Corr_delta(i) = tline(i+2, 2);
        i = i + 1;
     else
        Fault(i - corr_num,:) = tline(i+2, :);
        i = i + 1;
     end
end
for i = 1: fault_num
     Fault_delta(i, :) = tline( PEnum + 2 + i, :);
end
disp('Dolev Algorithm');
res1= dolev( PEnum, Corr, Fault );
disp ('FCA Algorithm');
res2= mahaney( PEnum, Corr, Corr_delta, Fault, Fault_delta );
disp ('Sensor Fusion Algorithm');
[list, ids, range ] = sensorfusion( PEnum, Corr, Corr_delta, Fault, Fault_delta );
disp ('Hybrid Algorithm');
%res3  = hybrid( PEnum, Corr,Corr_delta, Fault, Fault_delta );
