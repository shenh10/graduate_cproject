input = '../../../cv/tracker_benchmarks/data/otb100/Dancer/img';
ext = 'jpg';
D = dir(fullfile(input,['*.', ext]));
file_list={D.name};
start_frame = 1;
end_frame = numel(file_list);
groundtruth = fullfile(input,'../groundtruth_rect.txt');
total_gt = textread(groundtruth,'','delimiter',',');
init_rect = total_gt(1,:);
rect = init_rect;
m = 20;

for frame_id = start_frame:end_frame
figure(1);
I_orig=imread(fullfile(input,file_list{frame_id}));
imshow(I_orig);
if frame_id == start_frame
    I_crop =imcrop(I_orig,init_rect);
    [target_q,~] = color_distro(I_crop, m, 1);
    continue;
end

rect = kernel_ot( I_orig, target_q, m, rect );
rectangle('position',rect,'LineWidth',2,'EdgeColor','r');
rectangle('position',total_gt(frame_id,:),'LineWidth',2,'EdgeColor','b');

pause(0.01);
end