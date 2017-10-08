% display dialog to get location of output folder and output file name
[saveFile_name, save_folder] = uiputfile({'.jpg'},'Save Image')

% convert current dicom image to jpeg
imjpeg = uint8(mat2gray(handles.dim_image) * 255);

% write the current dicom image to the selected location as a jpeg
imwrite(imjpeg, [save_folder, saveFile_name]);
% save the related dicom info to the same location as a .mat file 
% with the same name
dcmInfo = handles.dim_info;
save([save_folder, saveFile_name, '.mat'], 'dcmInfo');

clear dcmInfo imjpeg