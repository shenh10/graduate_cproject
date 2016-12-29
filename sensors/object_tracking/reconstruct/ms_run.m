function  [rects] = ms_run( filepath, ext, option, use_gt, display )
% option: 'bg_scale', 'scale', 'normal'
if nargin < 5
    display = true;
end
if nargin < 4
    use_gt = false;
end
if nargin < 3
    option = 'bg_scale';
end
if nargin < 2
    ext = 'jpg';
end
myfile=dir([filepath,'*.', ext]);  
len_file =length(myfile);  
I=imread([filepath,myfile(1).name]);  
if ~ use_gt
% retrieve initial bounding box
    I=imread([filepath,myfile(1).name]);  
    figure(1);  
    imshow(I);  
    [I_crop,rect]=imcrop(I);  
    rect(3:4) = ceil(rect(3:4));
    close;
else
    [data] = textread(fullfile(filepath, '..', 'groundtruth_rect.txt'),'','delimiter',',');
    [sample, dim] = size(data);
    if dim ~= 4
       [data] = textread(fullfile(filepath, '..', 'groundtruth_rect.txt'),'','delimiter',' ');
    end
    rect = data(1,:);
    rect(3:4) = ceil(rect(3:4));
    I_crop = imcrop(I, rect );  
end
fprintf('Initial rect:\n');
disp(rect);
target_rect = rect;
[target_hist, ~, ~]=gen_hist(option, I,rect);
rects = [rect];
gamma = 0.1;
for l = 2:len_file
    Im=imread([filepath,myfile(l).name]);  
    switch option
        case 'normal'
            [ can_hist, rect ] = meanshift(Im , rect, target_hist, option);
            im_title = 'Fixed bounding box size';
            hist_title = 'Color distribution groundtruth vs predicted';
        case 'scale'
            scale_num = 5;
            ro = zeros(scale_num, 1);
            can_hist_s = zeros(scale_num, length(target_hist));
            rect_s = zeros(scale_num, 4);
            for i_scale = 1:scale_num
                can_rects = gen_rect('scale', rect, i_scale, scale_num);
                [ can_hist, can_rect ] = meanshift(Im , can_rects, target_hist,option );
                can_hist_s(i_scale,:) =  can_hist;
                rect_s(i_scale,:) = can_rect;
                ro(i_scale) = sum(sqrt(target_hist.*can_hist));
            end
            [rou, max_i] = max(ro);

            new_rect = rect_s(max_i,:);
            rect = new_rect * gamma +  rect* (1-gamma); 
            [ can_hist, rect ] = meanshift(Im , rect , target_hist, option );
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
            fprintf('value: %f, scale: %d\n', rou, max_i);
        case 'bg_scale'
            scale_num = 5;
            ro = zeros(scale_num, 1);
            can_hist_s = zeros(scale_num, length(target_hist));
            rect_s = zeros(scale_num, 4);
            for i_scale = 1:scale_num
                can_rects = gen_rect('scale', rect, i_scale, scale_num);
                [ can_hist, can_rect ] = meanshift(Im , can_rects, target_hist, option );
                can_hist_s(i_scale,:) =  can_hist;
                rect_s(i_scale,:) = can_rect;
                ro(i_scale) = sum(sqrt(target_hist.*can_hist));
            end
            [rou, max_i] = max(ro);
            new_rect = rect_s(max_i,:);
            rect = new_rect * gamma +  rect* (1-gamma); 
            [ can_hist, rect ] = meanshift(Im , rect , target_hist, option );
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';

            fprintf('value: %f, scale: %d\n', rou, max_i);
        case 'kalman'
            if l == 2
                last_x = [ rect(1) + rect(3)/2, rect(2) + rect(4)/2, 0.5, 0.5]';
                last_P = [100,0,0,0;0,100,0,0;0,0,100,0;0,0,0,100];
            end
            disp(last_x);
            disp(last_P);
            [ can_hist, this_rect ] = meanshift(Im , rect, target_hist, option);
            [ last_x ,last_P ] = exe_kalman( last_x, last_P, Im, target_rect, this_rect); 
            fprintf('tracker computed rect: (%f,%f,%f,%f)\n',this_rect(1),this_rect(2), this_rect(3),this_rect(4));
            rect = [ last_x(1) - this_rect(3)/2, last_x(2) - this_rect(4)/2, this_rect(3:4)];
            fprintf('kalman corrected rect: (%f,%f,%f,%f)\n',rect(1),rect(2), rect(3),rect(4));
            plot_tracking( Im, target_hist, can_hist, rect, 1, this_rect);
        otherwise
            fprintf('Not supported option;\n');
    end
    rects = [rects; rect]; 
    if display
        plot_tracking( Im, target_hist, can_hist, rect, im_title, hist_title, 1);
    end
end


end


