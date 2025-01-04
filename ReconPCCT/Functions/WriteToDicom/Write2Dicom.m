function [SN] = Write2Dicom(Image, DcmPara, AcqPara, RecPara,SN)
info = dicominfo('template.dcm','Dictionary','dicom-dict-2007-New.txt');
% info.StudyDate = AcqPara.StudyData;%
% info.AcquisitionDateTime = AcqPara.FileModDate;%
% info.StudyID = AcqPara.StudyID;%

info.PatientName = DcmPara.name;
info.PatientID = DcmPara.name;

info.ScanOptions = AcqPara.ScanMode;
info.SliceThickness = RecPara.fImgThickness;
info.KVP = AcqPara.kV;
% info.ProtocolName = AcqPara.ProtocolName;%
info.DistanceSourceToDetector = AcqPara.SDD;
info.DistanceSourceToPatient = AcqPara.SID;
info.ExposureTime = AcqPara.objExposureTime*1000;%s→ms
info.FilterType = AcqPara.FilterType;
info.ConvolutionKernel = RecPara.Kernel;
info.PixelSpacing = [RecPara.FOV/RecPara.Matrix(1);RecPara.FOV/RecPara.Matrix(2)];
info.WindowCenter = 1000; 
info.WindowWidth = 5000;
info.RescaleIntercept = -9192;
info.RescaleSlope = 1;
info.ScanFov = AcqPara.ScanFOV;
info.DetectorChannelNum = AcqPara.nChannelNum;
info.DetectorSliceNum = AcqPara.nSliceNum;
info.DetectorPixelSizeU = AcqPara.fDetU;
info.DetectorPixelSizeV = AcqPara.fDetV;
info.ThresholdNum = 2;
info.ThresholdValues = [AcqPara.LowEnergyThreshold;AcqPara.HighEnergyThreshold];
info.SpectralType = RecPara.SpectralType;%
info.TotalViewNum = AcqPara.nViewTotal;
info.PerRotViewNum = AcqPara.nViewPerRot;
info.FramesNumPerView = AcqPara.nFramesNumPerView;
% info.ScanAngle = AcqPara.fScanAngle;
info.ImageThicknesss = RecPara.fImgThickness;


path = DcmPara.path;
if ~exist(path,'dir')
    mkdir(path);
    if ~exist(path,'dir')
        error(['Cannot create directory ' path '!']);
    end
end

init_position = [0,0,RecPara.fStartPos];%mm

Data = reshape(Image,RecPara.Matrix(1)*RecPara.Matrix(2),RecPara.nImgNum);
is_SN = exist('SN');
if ~is_SN
    SN = 0;
end
for i=1:RecPara.nImgNum
    pic = Data(:,i);
    pic = reshape(pic,RecPara.Matrix);

    % pic = pic';
    pic = uint16(info.RescaleSlope*pic-info.RescaleIntercept);
    %pic = RotImgToDcm(pic,AcqPara.PatientPosition);

    info.ImagePositionPatient =init_position + [0,0,(i-1)*RecPara.fImgIncrement*AcqPara.CouchDir];
    info.SliceLocation = info.ImagePositionPatient(3);
    SN = SN+1;
    info.InstanceNumber = SN;
    
    status = dicomwrite( pic,[path '\'  num2str(info.InstanceNumber,'%05d') '.dcm'],info,'WritePrivate',true,'Dictionary','dicom-dict-2007-New.txt');

%     range=[info.WindowCenter-info.WindowWidth/2,info.WindowCenter+info.WindowWidth/2]+1024;
%     
%     img0=double(pic<range(1))*0+double(pic>range(2))+double(pic<=range(2)).*double(pic>=range(1)).*double(pic-range(1))./(range(2)-range(1));
%     imwrite(img0, [path '\'  num2str(info.InstanceNumber)  '.png'],'BitDepth',16);
end
end