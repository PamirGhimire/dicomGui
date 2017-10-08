% get current value of the slider
set(handles.slider1, 'value', round(get(handles.slider1, 'value')) );
nTotalFiles = length(handles.dim_files);
fileIndex = get(handles.slider1, 'value');

handles.dim_currentFileIdx = fileIndex;
guidata(hObject, handles);

% read the dicom image corresponding to this position
handles.dim_image = dicomread([handles.dim_folder, handles.dim_files(fileIndex).name]);
guidata(hObject, handles);

% display the current file index in the file index text-edit
set(handles.edit8, 'string', [num2str(fileIndex), '/', num2str(length(handles.dim_files))] );

% display it in the viewer
handles.axes2();
imshow(handles.dim_image, [])

% READ THE METADATA ASSOCIATED WITH THE FILENAME
handles.dim_info = dicominfo([handles.dim_folder, handles.dim_files(fileIndex).name]);
guidata(hObject, handles);


% DISPLAY THE METADATA IN THE METADATA PANEL:
% Name
patientName = [handles.dim_info.PatientName.FamilyName, ' ', handles.dim_info.PatientName.GivenName];
set(handles.edit1, 'string', patientName);
% ID
set(handles.edit2, 'string', handles.dim_info.PatientID);
% DOB:
set(handles.edit3, 'string', handles.dim_info.PatientBirthDate);
% Study ID:
set(handles.edit4, 'string', handles.dim_info.StudyID);
% Study Date:
set(handles.edit5, 'string', handles.dim_info.StudyDate);
% Slice Location:
set(handles.edit6, 'string', handles.dim_info.SliceLocation);
% Instance Number:
set(handles.edit7, 'string', handles.dim_info.InstanceNumber);

% Display the current annotations for the slice
show_annotations_for_current_folder;