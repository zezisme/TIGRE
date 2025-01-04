clear all
close all
cd 'E:\zhouenze\研究生\光子计数CT\成果\数据集\code_TIGRE' %修改成代码所在文件夹路径
% add TIGRE toolbox to the matlab path
addpath(genpath('~\TIGRE-master\MATLAB'))

% is_write2dicom = 1;
% data_dir_root  = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\投影保存\HeartInjection0.2ml\Couch_1\low';%待重建数据集路径
% save_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\Couch_1';%保存路径
% tic
% SN = 0;
% [SN] = TIGRE_recon_real_FDK_function(data_dir_root,save_path,is_write2dicom,SN);
% toc

is_write2dicom = 1;
data_dir_root  = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\投影保存\';%待重建数据集路径
save_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\';%保存路径
recon_type = 1;%1:FDK,2:OSART_20,3:OS-SART-TV
dose_ratio = 1;
recon_Bin = [1 1 1]; %Low,High,Total重建
%重建参数
recon_para.nVoxel =[1529;1529;400];  %重建矩阵大小
recon_para.sVoxel=[0;0;10];   %mm，重建实际FOV大小，当x,y大小为小于0时候，默认使用成像时FOV大小重建，z轴大小参考：FOV35:8.781;FOV50:10; FOV80:10; FOV100:18.9268    (mm)

ReconAllEnergy([data_dir_root,'HeartInjection0.2ml'],[save_path,'HeartInjection0.2ml\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'HeartInjection0.5ml'],[save_path,'HeartInjection0.5ml\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'NoContrast'],[save_path,'NoContrast\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'TailVeinInjection0.2ml'],[save_path,'TailVeinInjection0.2ml\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'TailVeinInjection0.5ml'],[save_path,'TailVeinInjection0.5ml\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'TailVeinInjection1ml'],[save_path,'TailVeinInjection1ml\ALL2'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);


data_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\';
save_data_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\';
cali_path = 'J:\2024.05.14动物实验\校正表\ReconCalibrationTable\'; %小鼠数据集（5月份实验）

is_save_WaterHAP = 1;
is_save_WaterI = 1;
is_save_HAPI = 0;
is_save_WaterHAPI = 0; %基于双能进行三物质分解
is_save_VirtualMonoImage = 0;
enable_index = [is_save_WaterHAP,is_save_WaterI,is_save_HAPI,is_save_WaterHAPI,is_save_VirtualMonoImage];
% DicomImageMDFunction([data_path,'HeartInjection0.2ml\ALL2\OS-SART-TV_FDK_50_50_200'],cali_path,[save_data_path,'HeartInjection0.2ml\ALL2\OS-SART-TV_FDK_50_50_200'],enable_index);
DicomImageMDFunction([data_path,'HeartInjection0.2ml\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'HeartInjection0.2ml\ALL2\FDK_TV_200_100'],enable_index);
DicomImageMDFunction([data_path,'HeartInjection0.5ml\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'HeartInjection0.5ml\ALL2\FDK_TV_200_100'],enable_index);
DicomImageMDFunction([data_path,'NoContrast\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'NoContrast\ALL2\FDK_TV_200_100'],enable_index);
DicomImageMDFunction([data_path,'TailVeinInjection0.2ml\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'TailVeinInjection0.2ml\ALL2\FDK_TV_200_100'],enable_index);
DicomImageMDFunction([data_path,'TailVeinInjection0.5ml\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'TailVeinInjection0.5ml\ALL2\FDK_TV_200_100'],enable_index);
DicomImageMDFunction([data_path,'TailVeinInjection1ml\ALL2\FDK_TV_200_100'],cali_path,[save_data_path,'TailVeinInjection1ml\ALL2\FDK_TV_200_100'],enable_index);


% recon_type = 1;%1:FDK,2:OSART_20,3:OS-SART-TV
% ReconAllEnergy([data_dir_root,'HeartInjection0.2ml'],[save_path,'HeartInjection0.2ml\ALL2'],is_write2dicom,recon_type);
% ReconAllEnergy([data_dir_root,'HeartInjection0.5ml'],[save_path,'HeartInjection0.5ml\ALL2'],is_write2dicom,recon_type);
% ReconAllEnergy([data_dir_root,'NoContrast'],[save_path,'NoContrast\ALL2'],is_write2dicom,recon_type);
% ReconAllEnergy([data_dir_root,'TailVeinInjection0.2ml'],[save_path,'TailVeinInjection0.2ml\ALL2'],is_write2dicom,recon_type);
% ReconAllEnergy([data_dir_root,'TailVeinInjection0.5ml'],[save_path,'TailVeinInjection0.5ml\ALL2'],is_write2dicom,recon_type);
% ReconAllEnergy([data_dir_root,'TailVeinInjection1ml'],[save_path,'TailVeinInjection1ml\ALL2'],is_write2dicom,recon_type);


% data_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\';
% save_data_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\';
% cali_path = 'J:\2024.05.14动物实验\校正表\ReconCalibrationTable\'; %小鼠数据集（5月份实验）
% 
% is_save_WaterHAP = 0;
% is_save_WaterI = 1;
% is_save_HAPI = 0;
% is_save_WaterHAPI = 0; %基于双能进行三物质分解
% is_save_VirtualMonoImage = 0;
% enable_index = [is_save_WaterHAP,is_save_WaterI,is_save_HAPI,is_save_WaterHAPI,is_save_VirtualMonoImage];
% 
% DicomImageMDFunction([data_path,'HeartInjection0.2ml\ALL2\FDK'],cali_path,[save_data_path,'HeartInjection0.2ml\ALL2\FDK'],enable_index);
% DicomImageMDFunction([data_path,'HeartInjection0.5ml\ALL2\FDK'],cali_path,[save_data_path,'HeartInjection0.5ml\ALL2\FDK'],enable_index);
% DicomImageMDFunction([data_path,'NoContrast\ALL2\FDK'],cali_path,[save_data_path,'NoContrast\ALL2\FDK'],enable_index);
% DicomImageMDFunction([data_path,'TailVeinInjection0.2ml\ALL2\FDK'],cali_path,[save_data_path,'TailVeinInjection0.2ml\ALL2\FDK'],enable_index);
% DicomImageMDFunction([data_path,'TailVeinInjection0.5ml\ALL2\FDK'],cali_path,[save_data_path,'TailVeinInjection0.5ml\ALL2\FDK'],enable_index);
% DicomImageMDFunction([data_path,'TailVeinInjection1ml\ALL2\FDK'],cali_path,[save_data_path,'TailVeinInjection1ml\ALL2\FDK'],enable_index);



