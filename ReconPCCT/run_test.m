clear all
close all
cd 'E:\zhouenze\研究生\光子计数CT\成果\数据集\code_TIGRE' %修改成代码所在文件夹路径
% add TIGRE toolbox to the matlab path
addpath(genpath('~\TIGRE-master\MATLAB')) %添加tigre重建代码位置

is_write2dicom = 1;%是否保存重建结果为dicom文件
data_dir_root  = 'J:\核桃（海大15组）\投影数据\';%待重建数据集根路径
save_path = 'J:\核桃（海大15组）\重建图像\';%保存根路径
% data_dir_root  = 'J:\2024.4.29\核桃成像\开源重建\';%待重建数据集根路径
% save_path = 'I:\核桃数据集\开源重建\重建图像\';%保存根路径
% data_dir_root  = 'I:\校正实验重建数据\海大设备校正实验\投影数据\';%待重建数据集根路径
% save_path = 'I:\校正实验重建数据\海大设备校正实验\重建图像\';%保存根路径
% data_dir_root  = 'I:\校正实验重建数据\海大设备校正实验\硬化校正\投影数据\';%待重建数据集根路径
% save_path = 'I:\校正实验重建数据\海大设备校正实验\硬化校正\重建图像\';%保存根路径
% data_dir_root  = 'I:\校正实验重建数据\硬化校正\投影数据\';%待重建数据集根路径
% save_path = 'I:\校正实验重建数据\硬化校正\重建图像\';%保存根路径
recon_type = 1;%1:FDK,2:FDK+TV.....
dose_ratio = 1; %重建剂量设置，1：全剂量，2：只选择1/2角度剂量；以此类推......
recon_Bin = [1 1 1]; %Low,High,Total重建；1:重建该能量，0：不重建
%重建参数
recon_para.nVoxel =[1529;1529;400];  %重建矩阵大小
recon_para.sVoxel=[50;50;15];   %mm，重建实际FOV大小，当x,y大小为小于0时候，默认使用成像时FOV大小重建，z轴大小参考：FOV35:8.781;FOV50:10; FOV80:10; FOV100:18.9268    (mm)
% ReconAllEnergy([data_dir_root,'20241216_haida_FOV_80_核桃1_MEPPC_PMMA_AL'],[save_path,'20241216_haida_FOV_80_核桃1_MEPPC_PMMA_AL\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'20241216_haida_FOV_80_核桃2_MEPPC_PMMA_AL'],[save_path,'20241216_haida_FOV_80_核桃2_MEPPC_PMMA_AL\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);

% ReconAllEnergy([data_dir_root,'20241217_双材料模体PMMA_Ca_MEPPC_BHcorr'],[save_path,'20241217_双材料模体PMMA_Ca_MEPPC_BHcorr\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
% ReconAllEnergy([data_dir_root,'20240514_M7_AllSlice_无造影_协议1_10'],[save_path,'20240514_M7_AllSlice_无造影_协议1_10\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
% ReconAllEnergy([data_dir_root,'20240514_M7_AllSlice_无造影_协议1_MEPPC_BHcorr'],[save_path,'20240514_M7_AllSlice_无造影_协议1_MEPPC_BHcorr\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
% ReconAllEnergy([data_dir_root,'20241125_小鼠无造影_MEPPC'],[save_path,'20241125_小鼠无造影_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);


% ReconAllEnergy([data_dir_root,'20241217_均匀模体_PMMA_MEPPC'],[save_path,'20241217_均匀模体_PMMA_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
% ReconAllEnergy([data_dir_root,'核桃品种选择测试_核桃1破_MEPPC'],[save_path,'核桃品种选择测试_核桃1破_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'核桃品种选择测试_核桃2_MEPPC'],[save_path,'核桃品种选择测试_核桃2_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'核桃品种选择测试_核桃2破_MEPPC'],[save_path,'核桃品种选择测试_核桃2破_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);

% ReconAllEnergy([data_dir_root,'StepAndShoot核桃测试_MEPPC'],[save_path,'StepAndShoot核桃测试_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'新仓核桃测试_MEPPC'],[save_path,'新仓核桃测试_MEPPC\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);

% ReconAllEnergy([data_dir_root,'StepAndShoot核桃测试'],[save_path,'StepAndShoot核桃测试\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'新仓核桃测试'],[save_path,'新仓核桃测试\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);

% ReconAllEnergy([data_dir_root,'haida_核桃多床'],[save_path,'haida_核桃多床\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'无仓核桃测试'],[save_path,'无仓核桃测试\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);

% ReconAllEnergy([data_dir_root,'data2'],[save_path,'data2\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% %重建多个任务可以直接重复上一条代码即可，例如：
% ReconAllEnergy([data_dir_root,'data3'],[save_path,'data3\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'data4'],[save_path,'data4\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'data5'],[save_path,'data5\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);
% ReconAllEnergy([data_dir_root,'data6'],[save_path,'data6\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin);