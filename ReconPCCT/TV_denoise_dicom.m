clear all


% data_path = 'K:\核桃（2024.12.01）\导出\1.2.156.112605.66988328403511.241201134656.2.26496.18597\1.2.156.112605.66988328403511.241201134734.6.26496.49839';
% save_data_path = 'K:\核桃（2024.12.01）\导出\1.2.156.112605.66988328403511.241201134656.2.26496.18597\1.2.156.112605.66988328403511.241201134734.6.26496.49839';
% data_path = 'K:\核桃（2024.12.01）\80kvp脑协议\1.2.156.112605.66988328403511.241202065447.2.30584.14960\1.2.156.112605.66988328403511.241202065954.6.30584.48660';
% save_data_path = 'K:\核桃（2024.12.01）\80kvp脑协议\1.2.156.112605.66988328403511.241202065447.2.30584.14960\1.2.156.112605.66988328403511.241202065954.6.30584.48660';
% data_path = 'K:\zhouenze\血管模体（2024.12.12）\50mgI_ml\1.2.156.112605.66988328403511.241212085244.2.2928.17847\1.2.156.112605.66988328403511.241212085902.6.2928.42714';
% data_path = 'K:\zhouenze\血管模体（2024.12.12）\50mg_ml碘克沙醇_满配协议\1.2.156.112605.66988328403511.241212131118.2.2928.17499\1.2.156.112605.66988328403511.241212131216.6.2928.44057';
% save_data_path = 'I:\血管模体\50mg_ml碘克沙醇_高分';
data_path = 'I:\核桃数据集\开源重建\重建图像';
save_data_path = 'I:\核桃数据集\开源重建\重建图像';

% TIGRE TVdenoise
TV_niter = 100; %FDK-TV200与OS-SART-TV50噪声方差差不多
TV_lambda = 50; %保真项与TV项比值，越大越与原始图像相近，200：部分情况下降噪不干净，100：多数情况下有较好降噪效果，但是有些情况会过渡平滑
slice_num = 400; %单次TV去噪slice总数，根据内存大小决定
ReconType = ['_TV','_',num2str(TV_niter),'_',num2str(TV_lambda)];

is_UIH_data = 0;
DicomTVdenoise([data_path,'\核桃品种选择测试_核桃1_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Pulp'],[save_data_path,'\核桃品种选择测试_核桃1_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Pulp',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
DicomTVdenoise([data_path,'\核桃品种选择测试_核桃1_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Shell'],[save_data_path,'\核桃品种选择测试_核桃1_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Shell',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
DicomTVdenoise([data_path,'\核桃品种选择测试_核桃2_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Pulp'],[save_data_path,'\核桃品种选择测试_核桃2_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Pulp',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
DicomTVdenoise([data_path,'\核桃品种选择测试_核桃2_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Shell'],[save_data_path,'\核桃品种选择测试_核桃2_MEPPC\ALL\FDK_Dose_1_TV_200_100\物质分解\Pulp_Shell\Shell',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);

% DicomTVdenoise([data_path,'\Low_bin\1.2.156.112605.66988328403511.241202065954.3.30584.55430'],[save_data_path,'\','Low_bin',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
% DicomTVdenoise([data_path,'\High_bin\1.2.156.112605.66988328403511.241202072026.3.30584.15734'],[save_data_path,'\','High_bin',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);

% DicomTVdenoise([data_path,'\Low_bin\1.2.156.112605.66988328403511.241201134734.3.26496.59839'],[save_data_path,'\','Low_bin',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
% DicomTVdenoise([data_path,'\High_bin\1.2.156.112605.66988328403511.241201141736.3.26496.16535'],[save_data_path,'\','High_bin',ReconType],TV_niter,TV_lambda,slice_num,is_UIH_data);
