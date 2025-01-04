function y = calcu_roi(picture,rois,r)
%% 计算图像roi圆形区域统计值
% roi:(n,2)
% r:roi半径
% y:(n,5),[roi_mean,roi_std,roi_var,roi_min,roi_max]
    im_size = size(picture);
    for n = 1:1:size(rois,1)
        location = squeeze(rois(n,:));
        k = 1;
        for i = 1:1:im_size(1)
            for j = 1:1:im_size(2)
                distance = sqrt((i-location(1))^2 + (j-location(2))^2);
                if distance<=r
                    roi_data(k) = picture(i,j);
                    k = k+1;
                end
            end
        end
        roi_mean = mean(roi_data);
        roi_var = var(roi_data);
        roi_std = std(roi_data);
        roi_min = min(roi_data);
        roi_max = max(roi_data);
        y(n,:)=[roi_mean,roi_std,roi_var,roi_min,roi_max];
    end
end