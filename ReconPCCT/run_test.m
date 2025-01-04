clear all
close all
cd 'E:\zhouenze\研究生\光子计数CT\成果\数据集\code_TIGRE' %修改成代码所在文件夹路径
% add TIGRE toolbox to the matlab path
addpath(genpath('~\TIGRE-master\MATLAB')) %添加tigre重建代码位置

is_write2dicom = 1;%是否保存重建结果为dicom文件
data_dir_root  = 'J:\核桃（海大15组）\投影数据\';%待重建数据集根路径
save_path = 'J:\核桃（海大15组）\重建图像\';%保存根路径

recon_type = 1;%1:FDK,2:FDK+TV.....
dose_ratio = 1; %重建剂量设置，1：全剂量，2：只选择1/2角度剂量；以此类推......
recon_Bin = [1 1 1]; %Low,High,Total重建；1:重建该能量，0：不重建
%重建参数
recon_para.nVoxel =[1529;1529;400];  %重建矩阵大小
recon_para.sVoxel=[0;0;15];   %mm，重建实际FOV大小，当x,y大小为小于等于0时候，默认使用成像时FOV大小重建，z轴大小参考：FOV35:8.781;FOV50:10; FOV80:10; FOV100:18.9268    (mm)
% 开始重建
ReconAllEnergy([data_dir_root,'20241216_haida_FOV_80_核桃1_MEPPC_PMMA_AL'],[save_path,'20241216_haida_FOV_80_核桃1_MEPPC_PMMA_AL\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
ReconAllEnergy([data_dir_root,'20241216_haida_FOV_80_核桃2_MEPPC_PMMA_AL'],[save_path,'20241216_haida_FOV_80_核桃2_MEPPC_PMMA_AL\ALL'],is_write2dicom,recon_type,dose_ratio,recon_Bin,recon_para);
