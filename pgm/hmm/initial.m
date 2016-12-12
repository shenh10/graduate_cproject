function [ init_state,trans_init,emission_init ] = initial(var_n,ob_n, random )
%INITIAL Summary of this function goes here
%   Detailed explanation goes here

if random == 1
    init_state = rand(var_n,1);
    init_state = init_state/sum(init_state);
    trans_init = rand(var_n,var_n);
    emission_init = rand(var_n,ob_n);
    for i = 1:var_n
        trans_init = trans_init./repmat(sum(trans_init,2),1,var_n);
        emission_init = emission_init ./repmat(sum(emission_init,2),1,ob_n);
    end
    disp('Initial transition matrix:');
    disp(trans_init);
    disp('Initial emission matrix:');
    disp(emission_init);
else
    init_state = [1./3,1./3,1./3]';
    trans_init = [0.6,0.4,0; 0.4,0.5, 0.1; 0.7, 0.2,0.1];
    emission_init = [0.3,0.7; 0.3,0.7; 0.6, 0.4];
end

end

