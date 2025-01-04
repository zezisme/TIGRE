function [SN] = TIGRE_recon_real_FDK_function(data_dir_root,save_path,is_write2dicom,SN)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This matlab script computes an FDK reconstruction for PCCT data sets
%
% author: Enze Zhou
% date:        2024.08.27
% last update: 2024.08.27
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Processing: %s \n',data_dir_root);

is_SN = exist('SN');
if ~is_SN
    SN = 0;
end

% load data
load([data_dir_root,'\','AcqPara.mat']);
file_list = dir([data_dir_root '\*.projdata']);
rawdata_proj = zeros(AcqPara.nChannelNum,AcqPara.nSliceNum,length(file_list));
for i=1:length(file_list)
    file_name = file_list(i).name;
    file_path = [data_dir_root,'\',file_name];
    fid = fopen(file_path,'r');
    proj = fread(fid,'float32');
    fclose(fid);
    proj = reshape(proj,AcqPara.nSliceNum,AcqPara.nChannelNum);
    rawdata_proj(:,:,i) = proj';
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
geo.nVoxel=[1529;1529;400];                   % number of voxels              (vx)
geo.sVoxel=[AcqPara.ScanFOV;AcqPara.ScanFOV;8.781];                  % total size of the image  8.781     (mm)
geo.sVoxel = double(geo.sVoxel);
geo.dVoxel=geo.sVoxel./geo.nVoxel;          % size of each voxel            (mm)
% Offsets
geo.offOrigin =[0;0;0];
geo.offDetector=[(AcqPara.nChannelNum/2-AcqPara.U0)/10;(AcqPara.nSliceNum/2-AcqPara.V0)/10];   % Offset of Detector     (mm)
% geo.COR=0;  
geo.mode='cone';

% Auxiliary
% geo.accuracy=0.5;            % Accuracy of FWD proj          (vx/sample)

% detector rotation
InpRot = deg2rad(AcqPara.InpRot);
geo.rotDetector=[InpRot;0;0];

angles = AcqPara.objViewAngle'; %(1,angle_num)
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
% FDK
tid = tic;
fprintf('FDK recon begin ...\n');
x=FDK(rawdata_proj,geo,angles,'filter',filter_type);
%   FDK(PROJ,GEO,ANGLES,OPT,VAL,...) uses options and values for solving. The
%   possible options in OPT are:
%
%   'parker': adds parker weights for limited angle scans. Default TRUE
%
%   'wang': adds detector offset weights. Default TRUE
%
%   'filter': selection of filter. Default 'ram-lak' (ramp)
%              options are: 
%                  'ram-lak' (ramp)
%                  'shepp-logan'
%                  'cosine'
%                  'hamming'  
%                  'hann'

fprintf(['FDK recon' ':total running time is %.3f s\n'], toc(tid));

% OS-SART
% niter=50;
% x =OS_SART(rawdata_proj,geo,angles,niter);

% 
x = x - 1000; % 转换成标准的HU格式

%% show result
% imshow(x(:,:,1),[]);
% imshow(x(:,:,50),[]);
% imshow(x(:,:,end),[]);

% 获取重建参数
RecPara.ReconType = 'FDK';
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
save([save_path,'\','recon_HU_FDK_RecPara_',AcqPara.Energy,'.mat'],'RecPara');

% WriteToDicom存图
% is_write2dicom = 1;
if is_write2dicom
    DcmPara.name = [AcqPara.Energy,'_FDK'];
    DcmPara.path = [save_path,'\','FDK','\',AcqPara.Energy];
    tic
    fprintf('WriteToDicom begin ...\n');
    SN = Write2Dicom(x, DcmPara, AcqPara, RecPara,SN);
    fprintf(['WriteToDicom' ':total running time is %.3f s\n'], toc);
else
    fid = fopen([save_path,'\','recon_HU_FDK_',AcqPara.Energy,'.data'],'w');
    x = reshape(x,[],1);
    fwrite(fid,x,'float32');
    fclose(fid);
end

end
