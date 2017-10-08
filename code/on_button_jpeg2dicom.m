% get location and name of jpeg file
[jpegFileName, jpegFolder] = uigetfile({'.jpg'}, 'Locate the jpeg image ');
jIm = imread([jpegFolder, jpegFileName]);

% get location and name of the dicom info file
[infoFileName, infoFolder] = uigetfile({'.mat'}, 'Locate the .mat file with DICOM information of the image');

% the loaded mat file must contain a variable called dcmInfo
load([infoFolder, infoFileName]);

% put the two together and save as dicom file
[saveFile_name, save_folder] = uiputfile({'.dcm' },'Save as DICOM',...
          'C:\Work\newfile.dcm');
      
dicomwrite(jIm, [save_folder, saveFile_name], dcmInfo);
     
