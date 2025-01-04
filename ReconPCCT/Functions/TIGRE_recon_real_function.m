function [SN] = TIGRE_recon_real_function(data_dir_root,save_path,is_write2dicom,SN,recon_type,dose_ratio,recon_para)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This matlab script computes an IR reconstruction for PCCT data sets
%
% author: Enze Zhou
% date:        2024.10.12
% last update: 2024.12.03
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Processing: %s \n',data_dir_root);
dose_ratio = max(fix(dose_ratio),1); %确保为正整数
is_SN = exist('SN');
if ~is_SN
    SN = 0;
end
% if SN==0
%     SN = 400;
%     return;
% end
% load data
load([data_dir_root,'\','AcqPara.mat']);
file_list = dir([data_dir_root '\*.projdata']);
rawdata_proj = zeros(AcqPara.nChannelNum,AcqPara.nSliceNum,fix(length(file_list)/dose_ratio));
n = 0;
for i=1:dose_ratio:length(file_list)
    n = n + 1;
    file_name = file_list(i).name;
    file_path = [data_dir_root,'\',file_name];
    fid = fopen(file_path,'r');
    proj = fread(fid,'float32');
    fclose(fid);
    proj = reshape(proj,AcqPara.nSliceNum,AcqPara.nChannelNum);
    rawdata_proj(:,:,n) = proj';
end
% permute data to TIGRE convention
rawdata_proj = permute(rawdata_proj, [2,1,3]);
rawdata_proj = single(rawdata_proj);
% set geo parameters
geo.DSD = AcqPara.SDD;                             % Distance Source Detector      (mm)
geo.DSO = AcqPara.SID;                             % Distance Source Origin        (mm)
% Detector parameters
geo.nDetector=[AcqPara.nChannelNum; AcqPara.nSliceNum];					% number of pixels              (px)
geo.dDetector=[AcqPara.fDetU; AcqPara.fDetV]; 					% size of each pixel            (mm)
geo.sDetector=geo.nDetector.*geo.dDetector; % total size of the detector    (mm)
% Image parameters
geo.nVoxel=recon_para.nVoxel;                   % number of voxels              (vx)
if(recon_para.sVoxel(1)>0&&recon_para.sVoxel(2)>0)
    geo.sVoxel=recon_para.sVoxel;                  % total size of the image  FOV35:8.781;FOV50:10; FOV80:10; FOV100:18.9268    (mm)
else
    geo.sVoxel=[AcqPara.ScanFOV;AcqPara.ScanFOV;recon_para.sVoxel(3)];                  % total size of the image  FOV35:8.781;FOV50:10; FOV80:10; FOV100:18.9268    (mm)
end
geo.sVoxel = double(geo.sVoxel);
geo.dVoxel=geo.sVoxel./geo.nVoxel;          % size of each voxel            (mm)
% Offsets
% geo.offOrigin =[0;0;0];
geo.offOrigin =zeros(3,size(rawdata_proj,3));
geo.offOrigin(3,:) = AcqPara.objViewCouchPosition(1:dose_ratio:end);
geo.offOrigin = geo.offOrigin - (geo.offOrigin(:,end)+geo.offOrigin(:,1))/2;
geo.offOrigin = geo.offOrigin(:,end:-1:1); %这里需要转换下（否则Helical重建会有伪影）
geo.offDetector=[(AcqPara.nChannelNum/2-AcqPara.U0)/10;(AcqPara.nSliceNum/2-AcqPara.V0)/10];   % Offset of Detector     (mm)
geo.COR=0;  %旋转中心偏移量
geo.mode='cone';
% Auxiliary
% geo.accuracy=1;            % Accuracy of FWD proj          (vx/sample)
% detector rotation
InpRot = deg2rad(AcqPara.InpRot);
geo.rotDetector=[InpRot;0;0];
angles = AcqPara.objViewAngle(1:dose_ratio:end)'; %(1,angle_num)
% permute angles to TIGRE convention (init angle: pi to 0)
angles = angles - pi;
filter_type = 'hann';
%   'filter': selection of filter. Default 'ram-lak' (ramp)
%              options are: 
%                  'ram-lak' (ramp)
%                  'shepp-logan'
%                  'cosine'
%                  'hamming'  
%                  'hann'
%注意：UIH LSI所用的soft滤波核就是hann，
%% Reconstruct image using OS-SART and FDK
tid = tic;
switch recon_type
    case 1
        % FDK
        ReconType = ['FDK_Dose_',num2str(dose_ratio)];
        fprintf('FDK recon begin ...\n');
        x=FDK(rawdata_proj,geo,angles,'filter',filter_type);
        fprintf(['FDK recon' ':total running time is %.3f s\n'], toc(tid));
    case 2
        % FDK
        fprintf('FDK-TV recon begin ...\n');
        x=FDK(rawdata_proj,geo,angles,'filter',filter_type);
        % TV denoising
        TV_niter = 200; %FDK-TV200与OS-SART-TV50噪声方差差不多
        TV_lambda = 100; %保真项与TV项比值，越大越与原始图像相近，200：部分情况下降噪不干净，100：多数情况下有较好降噪效果，但是有些情况会过渡平滑
        ReconType = ['FDK_Dose_',num2str(dose_ratio),'_TV','_',num2str(TV_niter),'_',num2str(TV_lambda)];
        % expand_slice = 5; %扩展边界，解决目前边界噪声问题（已解决）
        % x = cat(3,x(:,:,(expand_slice+1):-1:2),x);
        % x = cat(3,x,x(:,:,end-1:-1:(end-expand_slice)));
        fprintf('TV-denoising begin ...\n');
        x=im3DDenoise(x,'TV',TV_niter,TV_lambda,'gpuids',GpuIds());
        % x=x(:,:,expand_slice+1:1:end-expand_slice);
        fprintf(['FDK-TV recon' ':total running time is %.3f s\n'], toc(tid));
    case 3
        % OS-SART
        %为了避免迭代重建产生的严重锥束伪影，拓宽重建区域
        alpha = 8/5; %计算确定的
        geo.nVoxel(3)=geo.nVoxel(3)*alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)*alpha;                  % total size of the image  8.781     (mm)

        niter=30;
        ReconType = ['OS-SART_zeros_negtrue_',num2str(niter)];
        % x=FDK(rawdata_proj,geo,angles,'filter',filter_type); %选用FDK进行初始化
        % x = load('I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\ALL2\x.mat'); x = x.x; %初始化
        
        fprintf(['OS-SART recon begin: ',num2str(niter),' iterations',' ...\n']);
        [x,xL2,qualMeasOut]=OS_SART2(rawdata_proj,geo,angles,niter,'Init','none','BlockSize',40,'Verbose',1,'QualMeas',{'RMSE'},'nonneg',false,'lambda',10,'lambda_red',0.50);
        % [x,xL2,qualMeasOut] =OS_SART2(rawdata_proj,geo,angles,niter,'Init','image','initimg',x,'BlockSize',40,'Verbose',1,'QualMeas',{'RMSE'},'nonneg',false,'lambda',10,'lambda_red',0.50);
        
        fprintf(['OS-SART recon' ':total running time is %.3f s\n'], toc(tid));
        % 
        geo.nVoxel(3)=geo.nVoxel(3)/alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)/alpha; 
        x = x(:,:,geo.nVoxel(3)*(alpha-1)/2+1:geo.nVoxel(3)*(alpha+1)/2); %裁剪掉外面
    case 4
        %OS-SART-TV
        %为了避免迭代重建产生的严重锥束伪影，拓宽重建区域
        alpha = 8/5; %计算确定的
        geo.nVoxel(3)=geo.nVoxel(3)*alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)*alpha;                  % total size of the image  8.781     (mm)

        niter=50;
        BlockSize = 40;
        lambda = 10;
        lambda_red = 0.5;
        TV_niter = 50;
        TV_lambda = 200; %It gives the ratio of
%                  importance of the image vs the minimum total variation.
%                  default is 15. Lower means more TV denoising.
        ReconType = ['OS-SART-TV_FDK_',num2str(niter),'_',num2str(TV_niter),'_',num2str(TV_lambda)];
        % x=FDK(rawdata_proj,geo,angles,'filter',filter_type); %选用FDK进行初始化
        % x = load('I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\ALL2\x.mat'); x = x.x; %初始化
        fprintf(['OS-SART-TV recon begin: ',num2str(niter),' iterations',' ...\n']);
        [x,xL2,qualMeasOut] =OS_SART_TV(rawdata_proj,geo,angles,niter,'Init','FDK','BlockSize',BlockSize,'TViter',TV_niter,'TVlambda',TV_lambda,'lambda',lambda,'lambda_red',lambda_red);
        % [x,xL2,qualMeasOut] =OS_SART_TV(rawdata_proj,geo,angles,niter,'Init','image','initimg',x,'BlockSize',BlockSize,'TViter',TV_niter,'TVlambda',TV_lambda,'lambda',lambda,'lambda_red',lambda_red);
        fprintf(['OS-SART-TV recon' ':total running time is %.3f s\n'], toc(tid));
        % save([save_path,'\',ReconType,'_xL2.mat'],'xL2');
        % save([save_path,'\',ReconType,'_qualMeasOut.mat'],'qualMeasOut');
        % 
        geo.nVoxel(3)=geo.nVoxel(3)/alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)/alpha; 
        x = x(:,:,geo.nVoxel(3)*(alpha-1)/2+1:geo.nVoxel(3)*(alpha+1)/2); %裁剪掉外面
    case 5
        %OS-ASD-POCS
        %为了避免迭代重建产生的严重锥束伪影，拓宽重建区域
        alpha = 8/5; %计算确定的
        geo.nVoxel(3)=geo.nVoxel(3)*alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)*alpha;                  % total size of the image  8.781     (mm)

        niter=50;
        BlockSize = 40;
        lambda = 10;
        lambda_red = 0.5;
        TV_niter = 50;
        TV_lambda = 200; %It gives the ratio of
%                  importance of the image vs the minimum total variation.
%                  default is 15. Lower means more TV denoising.
        ReconType = ['OS-SART-TV_FDK_',num2str(niter),'_',num2str(TV_niter),'_',num2str(TV_lambda)];
        % x=FDK(rawdata_proj,geo,angles,'filter',filter_type); %选用FDK进行初始化
        % x = load('I:\小鼠实验（2024.5.14 And 7.10）\PIBM2024\重建图像\HeartInjection0.2ml\ALL2\x.mat'); x = x.x; %初始化
        fprintf(['OS-SART-TV recon begin: ',num2str(niter),' iterations',' ...\n']);
        [x,xL2,qualMeasOut] =OS_ASD_POCS(rawdata_proj,geo,angles,niter,'Init','FDK','BlockSize',BlockSize,'TViter',TV_niter,'TVlambda',TV_lambda,'lambda',lambda,'lambda_red',lambda_red);
        % [x,xL2,qualMeasOut] =OS_SART_TV(rawdata_proj,geo,angles,niter,'Init','image','initimg',x,'BlockSize',BlockSize,'TViter',TV_niter,'TVlambda',TV_lambda,'lambda',lambda,'lambda_red',lambda_red);
        fprintf(['OS-SART-TV recon' ':total running time is %.3f s\n'], toc(tid));
        % save([save_path,'\',ReconType,'_xL2.mat'],'xL2');
        % save([save_path,'\',ReconType,'_qualMeasOut.mat'],'qualMeasOut');
        % 
        geo.nVoxel(3)=geo.nVoxel(3)/alpha;                   % number of voxels              (vx)
        geo.sVoxel(3)=geo.sVoxel(3)/alpha; 
        x = x(:,:,geo.nVoxel(3)*(alpha-1)/2+1:geo.nVoxel(3)*(alpha+1)/2); %裁剪掉外面
end
x = x - 1000; % 转换成标准的HU格式

%% show result
% imshow(x(:,:,1),[]);
% imshow(x(:,:,50),[]);
% imshow(x(:,:,end),[]);

% 获取重建参数
RecPara.ReconType = ReconType;
RecPara.Kernel = filter_type;
RecPara.iFirImg = 0;
RecPara.iEndImg = geo.nVoxel(3)-1;
RecPara.nImgNum = geo.nVoxel(3);
RecPara.FOV = geo.sVoxel(1);
RecPara.Matrix = [geo.nVoxel(1),geo.nVoxel(2)];
RecPara.fCenter = geo.offOrigin;
RecPara.fImgThickness = geo.dVoxel(3);
RecPara.fImgIncrement = geo.dVoxel(3);
fCouchPos = AcqPara.objViewCouchPosition(1); %adapt to continuous scan
RecPara.fStartPos = fCouchPos-geo.sVoxel(3)/2;
RecPara.fEndPos  = fCouchPos+geo.sVoxel(3)/2;
RecPara.objViewAngle = angles;        % 增加实际扫描角度
RecPara.SpectralType = AcqPara.Energy;

% 保存重建参数
if ~exist(save_path,'dir')
    mkdir(save_path);
end
save([save_path,'\','recon_HU_',ReconType,'_RecPara_',AcqPara.Energy,'.mat'],'RecPara');

% WriteToDicom存图
% is_write2dicom = 1;
if is_write2dicom
    DcmPara.name = [AcqPara.Energy,'_',ReconType];
    DcmPara.path = [save_path,'\',ReconType,'\',AcqPara.Energy];
    tic
    fprintf('WriteToDicom begin ...\n');
    SN = Write2Dicom(x, DcmPara, AcqPara, RecPara,SN);
    fprintf(['WriteToDicom' ':total running time is %.3f s\n'], toc);
else
    fid = fopen([save_path,'\','recon_HU_',ReconType,'_',AcqPara.Energy,'.data'],'w');
    x = reshape(x,[],1);
    fwrite(fid,x,'float32');
    fclose(fid);
end

end
