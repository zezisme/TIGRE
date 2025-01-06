function MaterialPairDicomSave(MaterialPair, flag, savepath, info)
% % save dual basis material pair image as .dcm
% Input
%   MaterialPair: a struct, containing specified dual basis material pair image
%   flag: MaterialDecomposition parameter
%   savepath: image save path
%   info: corresponding low image dicominfo
% 
% Written by enze.zhou 2024.08.28

M1 = MaterialPair.M1*1000;  % 由g/cm3转换为mg/cm3
M2 = MaterialPair.M2*1000;
namenum = num2str(info.InstanceNumber,'%05d');
if flag == 0  % Water-HA
    path1 = [savepath,'\Water_HA\Water'];
    path2 = [savepath,'\Water_HA\HA'];
    StudyID1 = 'Water_HA_M1';
    SeriesID1 = 'Water_HA_M1';
    StudyID2 = 'Water_HA_M2';
    SeriesID2 = 'Water_HA_M2';
    RescaleIntercept1 = -5000;
    RescaleSlope1 = 1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 1  % Water-I
    path1 = [savepath,'\Water_Iodine\Water'];
    path2 = [savepath,'\Water_Iodine\Iodine'];
    StudyID1 = 'Water_Iodine_M1';
    SeriesID1 = 'Water_Iodine_M1';
    StudyID2 = 'Water_Iodine_M2';
    SeriesID2 = 'Water_Iodine_M2';
    RescaleIntercept1 = -5000;
    RescaleSlope1 = 1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 2  % HA-I
    path1 = [savepath,'\HA_Iodine\HA'];
    path2 = [savepath,'\HA_Iodine\Iodine'];
    StudyID1 = 'HA_Iodine_M1';
    SeriesID1 = 'HA_Iodine_M1';
    StudyID2 = 'HA_Iodine_M2';
    SeriesID2 = 'HA_Iodine_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 3  % water-Au
    path1 = [savepath,'\Water_Au\Water'];
    path2 = [savepath,'\Water_Au\Au'];
    StudyID1 = 'Water_Au_M1';
    SeriesID1 = 'Water_Au_M1';
    StudyID2 = 'Water_Au_M2';
    SeriesID2 = 'Water_Au_M2';
    RescaleIntercept1 = -5000;
    RescaleSlope1 = 1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 4  % I-Au
    path1 = [savepath,'\Iodine_Au\Iodine'];
    path2 = [savepath,'\Iodine_Au\Au'];
    StudyID1 = 'Iodine_Au_M1';
    SeriesID1 = 'Iodine_Au_M1';
    StudyID2 = 'Iodine_Au_M2';
    SeriesID2 = 'Iodine_Au_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 5  % HA-Au
    path1 = [savepath,'\HA_Au\HA'];
    path2 = [savepath,'\HA_Au\Au'];
    StudyID1 = 'HA_Au_M1';
    SeriesID1 = 'HA_Au_M1';
    StudyID2 = 'HA_Au_M2';
    SeriesID2 = 'HA_Au_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
elseif flag == 6  % Water-Oil
    M1 = MaterialPair.M1*100;  % 转换为浓度百分比
    M2 = MaterialPair.M2*100;
    path1 = [savepath,'\Water_Oil\Water'];
    path2 = [savepath,'\Water_Oil\Oil'];
    StudyID1 = 'Water_Oil_M1';
    SeriesID1 = 'Water_Oil_M1';
    StudyID2 = 'Water_Oil_M2';
    SeriesID2 = 'Water_Oil_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
    info.WindowCenter = 100;
    info.WindowWidth = 1000;
elseif flag == 7  % Alcohol-Oil
    M1 = MaterialPair.M1*100;  % 转换为浓度百分比
    M2 = MaterialPair.M2*100;
    path1 = [savepath,'\Alcohol_Oil\Alcohol'];
    path2 = [savepath,'\Alcohol_Oil\Oil'];
    StudyID1 = 'Alcohol_Oil_M1';
    SeriesID1 = 'Alcohol_Oil_M1';
    StudyID2 = 'Alcohol_Oil_M2';
    SeriesID2 = 'Alcohol_Oil_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
    info.WindowCenter = 100;
    info.WindowWidth = 1000;
elseif flag == 8  % Pulp_Shell
    M1 = MaterialPair.M1*100;  % 转换为占比百分比
    M2 = MaterialPair.M2*100;
    path1 = [savepath,'\Pulp_Shell\Pulp'];
    path2 = [savepath,'\Pulp_Shell\Shell'];
    StudyID1 = 'Pulp_Shell_M1';
    SeriesID1 = 'Pulp_Shell_M1';
    StudyID2 = 'Pulp_Shell_M2';
    SeriesID2 = 'Pulp_Shell_M2';
    RescaleIntercept1 = -2500;
    RescaleSlope1 = 0.1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
    info.WindowCenter = 100;
    info.WindowWidth = 1000;
else
    error('DualBasis: not support the dual material basis!');
end
if exist(path1,'dir') ~=7
    mkdir(path1);
end
if exist(path2,'dir') ~=7
    mkdir(path2);
end 

info.StudyID = StudyID1; 
info.SeriesInstanceUID = SeriesID1;
info.RescaleIntercept = RescaleIntercept1;
info.RescaleSlope = RescaleSlope1;
info.SeriesDescription = StudyID1;
temp = uint16((M1-info.RescaleIntercept)./info.RescaleSlope);
path = [path1, '\', namenum, '.dcm'];
% status = dicomwrite(temp,path,info,'WritePrivate',true,'Dictionary','dicom-dict-2007-New.txt');
status = dicomwrite(temp,path,info);

info.StudyID = StudyID2; 
info.SeriesInstanceUID = SeriesID2;
info.RescaleIntercept = RescaleIntercept2;
info.RescaleSlope = RescaleSlope2;
info.SeriesDescription = StudyID2;
temp = uint16((M2-info.RescaleIntercept)./info.RescaleSlope);
path = [path2, '\', namenum, '.dcm'];
% status = dicomwrite(temp,path,info,'WritePrivate',true,'Dictionary','dicom-dict-2007-New.txt');
status = dicomwrite(temp,path,info);
end