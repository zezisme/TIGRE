function Material3DicomSave(MaterialPair, flag, savepath, info)
% % save triple material pair image as .dcm
% Input
%   MaterialPair: a struct, containing specified dual basis material pair image
%   flag: MaterialDecomposition parameter
%   savepath: image save path
%   info: corresponding low image dicominfo
% 
% Written by enze.zhou 2024.08.28

M1 = MaterialPair.M1*1000;  % 由g/cm3转换为mg/cm3
M2 = MaterialPair.M2*1000;
M3 = MaterialPair.M3*1000;
namenum = num2str(info.InstanceNumber,'%05d');
if flag == 0  % Water-HA-I
    path1 = [savepath,'\Water_HA_I\Water'];
    path2 = [savepath,'\Water_HA_I\HA'];
    path3 = [savepath,'\Water_HA_I\I'];
    StudyID1 = 'Water_HA_I_M1';
    SeriesID1 = 'Water_HA_I_M1';
    StudyID2 = 'Water_HA_I_M2';
    SeriesID2 = 'Water_HA_I_M2';
    StudyID3 = 'Water_HA_I_M3';
    SeriesID3 = 'Water_HA_I_M3';
    RescaleIntercept1 = -5000;
    RescaleSlope1 = 1;
    RescaleIntercept2 = -2500;
    RescaleSlope2 = 0.1;
    RescaleIntercept3 = -2500;
    RescaleSlope3 = 0.1;
else
    error('TripleBasis: not support the Triple material basis!');
end
if exist(path1,'dir') ~=7
    mkdir(path1);
end
if exist(path2,'dir') ~=7
    mkdir(path2);
end 
if exist(path3,'dir') ~=7
    mkdir(path3);
end 

info.StudyID = StudyID1; 
info.SeriesInstanceUID = SeriesID1;
info.RescaleIntercept = RescaleIntercept1;
info.RescaleSlope = RescaleSlope1;
info.SeriesDescription = StudyID1;
temp = uint16((M1-info.RescaleIntercept)./info.RescaleSlope);
path = [path1, '\', namenum, '.dcm'];
dicomwrite(temp,path,info);

info.StudyID = StudyID2; 
info.SeriesInstanceUID = SeriesID2;
info.RescaleIntercept = RescaleIntercept2;
info.RescaleSlope = RescaleSlope2;
info.SeriesDescription = StudyID2;
temp = uint16((M2-info.RescaleIntercept)./info.RescaleSlope);
path = [path2, '\', namenum, '.dcm'];
dicomwrite(temp,path,info);

info.StudyID = StudyID3; 
info.SeriesInstanceUID = SeriesID3;
info.RescaleIntercept = RescaleIntercept3;
info.RescaleSlope = RescaleSlope3;
info.SeriesDescription = StudyID3;
temp = uint16((M3-info.RescaleIntercept)./info.RescaleSlope);
path = [path3, '\', namenum, '.dcm'];
dicomwrite(temp,path,info);
end