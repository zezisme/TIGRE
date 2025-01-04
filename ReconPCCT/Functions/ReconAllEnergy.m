function [] = ReconAllEnergy(data_dir_root,save_path,is_write2dicom,recon_type,dose_ratio,recon_bin,recon_para)
% is_write2dicom = 1;
% data_dir_root  = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\投影保存\HeartInjection0.2ml';%待重建数据集路径
% save_path = 'I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\ALL';%保存路径

file_list = dir(data_dir_root);
file_list = file_list(3:end);

if recon_bin(1)
    tid = tic;
    fprintf('%s projdata recon begin ...\n','low');
    SN = 0;
    for i=1:length(file_list)
        file_name = file_list(i).name;
        file_path = [data_dir_root,'\',file_name,'\','low'];
        SN = TIGRE_recon_real_function(file_path,save_path,is_write2dicom,SN,recon_type,dose_ratio,recon_para);
    end
    fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))
end

if recon_bin(2)
    tid = tic;
    fprintf('%s projdata recon begin ...\n','high');
    SN = 0;
    for i=1:length(file_list)
        file_name = file_list(i).name;
        file_path = [data_dir_root,'\',file_name,'\','high'];
        SN = TIGRE_recon_real_function(file_path,save_path,is_write2dicom,SN,recon_type,dose_ratio,recon_para);
    end
    fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))
end

if recon_bin(3)
    tid = tic;
    fprintf('%s projdata recon begin ...\n','total');
    SN = 0;
    for i=1:length(file_list)
        file_name = file_list(i).name;
        file_path = [data_dir_root,'\',file_name,'\','total'];
        SN = TIGRE_recon_real_function(file_path,save_path,is_write2dicom,SN,recon_type,dose_ratio,recon_para);
    end
    fprintf('#####  Recon : total running time is %.3f s  #####\n', toc(tid))
end
end