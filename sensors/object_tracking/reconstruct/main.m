close all; 
clear all;  
clc;
data_path = '../data/results/';
if ~exist(data_path)
    mkdir(data_path);
end
cases = [{'normal'}, {'scale'}, {'bg_scale'},{'bg_scale_amp'},{'bg_scale_lb'},{'kalman_fv'}];
video_path = '../../../../cv/tracker_benchmarks/data/otb100/Walking/img/';
predict = 1;
if predict
for c = 1: length(cases)
    fname = fullfile([ data_path, cases{c}, '.mat']);
    if exist(fname)
        continue;
    end
    disp(cases{c});
    [rects] = ms_run( video_path , 'jpg', cases{c}, true, false );
    save(fname, 'rects');
end
end

colors = 'yrbgmkc';
case_name = ['groundtruth',cases];
% load groundtruth
[gt] = textread(fullfile(video_path, '..', 'groundtruth_rect.txt'),'','delimiter',',');
[sample, dim] = size(gt);
if dim ~= 4
   [gt] = textread(fullfile(video_path, '..', 'groundtruth_rect.txt'),'','delimiter',' ');
end
rects_all = zeros(length(case_name), 4, length(gt));
rects_all(1,:,:) = gt';
for i = 1:length(cases)
    load(fullfile([ data_path, cases{i}, '.mat']));
    rects_all(i+1,:,:) = rects';
end
plot_compare(video_path, rects_all, case_name, colors, data_path, 1);


