function snn_migrate( mlp_net, images )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dt = 0.1; %ms
T = 10; %ms
V_reset = -60; %mV
layers = numel(mlp_net.layers);
test_image = images.data(:,:,:,images.set == 3);
test_label = images.labels(images.set == 3);

[~,~,~,N] = size(test_image);
step = T/dt;
class = 10;
error = 0;
error5 = 0;
error_rate = zeros(N,2);
figure;
for i = 1: N
    counter = zeros(class,1);
    subcounter = zeros(3,1);
%     subc = zeros(3,1);
    Vneutron = [];
    for l = 1:layers
    if strcmp( mlp_net.layers{l}.type, 'conv') == 1
        [f1,f2,~,n] = size(mlp_net.layers{l}.weights{1});
        Vneutron = [ Vneutron, {ones(n,1)*V_reset} ];
    end
    end
    for s = 1:step
        Spikes = SpikeGenerator(squeeze(test_image(:,:,1,i)));
        nlayer = 1;
        for l = 1:layers
            if strcmp( mlp_net.layers{l}.type, 'conv') == 1
            n = length(Vneutron{nlayer});
            Spikes_new = zeros(n,1);
            for j = 1: n
                X = sum(sum(squeeze(mlp_net.layers{l}.weights{1}(:,:,:,j)).*Spikes));
                X = max(0,X);
                [Vneutron{nlayer}(j), spike] = LIF(Vneutron{nlayer}(j),X, nlayer);
                Spikes_new(j) = spike;
            end
            Spikes = Spikes_new;
%              if sum(Spikes)> 0 
%                  subcounter(nlayer) = subcounter(nlayer) + sum(Spikes);
%              end
            nlayer = nlayer + 1;
            end
        end
        counter = counter + Spikes;
    end
    [counter,loc] = sort(counter,'descend');
    if ~ismember(test_label(i), loc(1:5))
        error5 = error5 + 1;
    end
    error = error + double(loc(1) ~= test_label(i));
    disp(sprintf('predict digit: %d, actual digit: %d', loc(1), test_label(i)));
    error_rate(i,1) = error / i;
    error_rate(i,2) = error5 / i;
    if mod(i, 100) == 0
        title('Error Rate of SNN');
        plot(error_rate(1:i,1));
        legend('Top-1 error');
        hold on;
        plot(error_rate(1:i,2));
        legend('Top-1 error','Top-5 error' );
        xlabel('Number of Testing Samples');
        ylabel('Error Rate');
        drawnow ;
    end
end

function spikes = SpikeGenerator(image)
    c = 1/3;
    [row, col] = size(image);
    spikes = single((rand(row, col)-0.5) < c* image);
%    disp(sprintf('spikegenerator: %d', sum(sum(spikes))));
end

function [V_out, Spike] = LIF(V_in ,X, nlayer)
Spike = 0;
tau_m = 1; %ms
V_reset = -60; %mV
%V_ths = [-75, -69.99, -70.8];
V_th = -30;
alpha = 20;
R = tau_m*(V_th-V_reset);
% do leaky integrate-and-fire simulation
V_out = V_in+ dt/tau_m*R*(alpha*X);
%V(i) = x(end,1);
if V_out >= V_th
    Spike = 1;
    V_out = V_reset;
end
if V_out <= V_reset
    V_out = V_reset;
end
end
end
