function DicomTVdenoise(data_path,save_data_path,TV_niter,TV_lambda,slice_num,is_UIH_data)

file_list = dir([data_path '\*.dcm']);
if is_UIH_data
    % 适用于UIH大软件生成的图像
    name_list = zeros(length(file_list),1);
    for i = 1:length(file_list)
        name = file_list(i).name;
        name = split(name,'.');
        name = str2num(cell2mat(name(6)))*1000000+str2num(cell2mat(name(9)));
        name_list(i) = name;
    end
    [~,index] = sort(name_list);
    file_list = file_list(index);
else

end

%保存为dicom
path = save_data_path;
if exist(path,'dir') ~=7
    mkdir(path);
end

info = dicominfo([file_list(1).folder,'\',file_list(1).name]);
img = double(dicomread(info));
size_img = size(img);
patch_num = fix(size(file_list,1)/slice_num);
if (size(file_list,1) - patch_num*slice_num)>slice_num/2
    patch_num = patch_num + 1;
end
patch_num = max(patch_num,1);
for k=1:patch_num
    disp(['当前进度： ',num2str(k),'/',num2str(patch_num),' ......']);
    if k==patch_num
        slices_num = size(file_list,1) - (k-1)*slice_num;
    else
        slices_num = slice_num;
    end
    imgs = zeros(size_img(1),size_img(2),slices_num,"single");
    for i=1:1:slices_num
        index = (k-1)*slice_num + i;
        info = dicominfo([file_list(index).folder,'\',file_list(index).name]);
        img = single(dicomread(info));
        img = img.*info.RescaleSlope + info.RescaleIntercept;
        % CT+1000
        img = img+1000;
        imgs(:,:,i) = img;
    end
    % TIGRE TVdenoise
    % start_num = ((k-1)*slice_num+1);
    % end_num = ((k-1)*slice_num+slices_num);
    imgs=im3DDenoise(imgs,'TV',TV_niter,TV_lambda,'gpuids',GpuIds());
    %保存为dicom
    for i=1:1:slices_num
        index = (k-1)*slice_num + i;
        info = dicominfo([file_list(index).folder,'\',file_list(index).name]);
        temp = squeeze(imgs(:,:,i));
        temp = temp - 1000;% 转换成标准的HU格式
        temp = uint16((temp-info.RescaleIntercept)./info.RescaleSlope);
        path2 = [path,'\',num2str(index,'%05d') '.dcm']; 
        dicomwrite(temp,path2,info);
    end
end