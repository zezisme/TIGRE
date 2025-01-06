function SubImagingDicomSave(Image, savepath, info)
% % save Image domain subtraction imaging image as .dcm
% Input
%   MonoImage: a struct, containing specified dual basis material pair image
%   savepath: image save path
%   info: corresponding low image dicominfo
% 
% Written by enze.zhou 2024.08.28

namenum = num2str(info.InstanceNumber);

path1 = [savepath,'\SubImaging\'];
StudyID1 = 'SubImaging';
SeriesID1 = 'SubImaging';
RescaleIntercept = -9192;
RescaleSlope = 1;

if exist(path1,'dir') ~=7
    mkdir(path1);
end

info.StudyID = StudyID1; 
info.SeriesInstanceUID = SeriesID1;
info.RescaleIntercept = RescaleIntercept;
info.RescaleSlope = RescaleSlope;
info.SeriesDescription = 'Image domain subtraction imaging';
temp = uint16((Image-info.RescaleIntercept)./info.RescaleSlope);
path = [path1, '\', namenum, '.dcm'];
dicomwrite(temp,path,info);

end