% clear all
% close all
cd 'E:\zhouenze\研究生\光子计数CT\成果\数据集\code_TIGRE' %修改成代码所在文件夹路径
% add TIGRE toolbox to the matlab path
addpath(genpath('~\TIGRE-master\MATLAB'))

is_write2dicom = 1;
% data_dir_root  = 'J:\2024.05.14动物实验\投影保存\开源重建\HeartInjection0.2ml';%待重建数据集路径
data_dir_root  = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\投影保存\HeartInjection0.2ml';%待重建数据集路径
save_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\ALL';%保存路径

file_list = dir(data_dir_root);
file_list = file_list(3:end);

tid = tic;
fprintf('%s projdata recon begin ...\n','low');
SN = 0;
for i=1:length(file_list)
    file_name = file_list(i).name;
    file_path = [data_dir_root,'\',file_name,'\','low'];
    SN = TIGRE_recon_real_FDK_function(file_path,save_path,is_write2dicom,SN);
end
fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))

tid = tic;
fprintf('%s projdata recon begin ...\n','high');
SN = 0;
for i=1:length(file_list)
    file_name = file_list(i).name;
    file_path = [data_dir_root,'\',file_name,'\','high'];
    SN = TIGRE_recon_real_FDK_function(file_path,save_path,is_write2dicom,SN);
end
fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))

tid = tic;
fprintf('%s projdata recon begin ...\n','total');
SN = 0;
for i=1:length(file_list)
    file_name = file_list(i).name;
    file_path = [data_dir_root,'\',file_name,'\','total'];
    SN = TIGRE_recon_real_FDK_function(file_path,save_path,is_write2dicom,SN);
end
fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))