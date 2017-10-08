% Locate DICOM files
folder = uigetdir('Select folder containing DICOM files');
folder = [folder, '\']
handles.dim_folder = folder;

dcmFiles = dir([folder, '*.dcm']);
if (~isempty(dcmFiles))
    handles.dim_files = dcmFiles;
else
    handles.dim_files = dir([folder, 'Im*']);
end

handles.dim_currentFileIdx = 1;
guidata(hObject, handles);

length(handles.dim_files)
% READ THE FIRST DICOM IMAGE IN THE IMAGE CONTAINING FOLDER
handles.dim_image = dicomread([handles.dim_folder, handles.dim_files(1).name]);
guidata(hObject, handles);

% SET THE SLIDER POSITION TO POSITION OF FIRST IMAGE IN THE DATABSE
set(handles.slider1, 'min', 1); 
set(handles.slider1, 'max', length(handles.dim_files));
set(handles.slider1, 'value', 1);
set(handles.slider1, 'SliderStep', [1/(length(handles.dim_files)), 1/(length(handles.dim_files))] );
guidata(hObject, handles);

% READ THE METADATA ASSOCIATED WITH a FILENAME
handles.dim_filename = [handles.dim_folder, handles.dim_files(1).name];
handles.dim_info = dicominfo(handles.dim_filename);
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

% DISPLAY THE DICOM IMAGE IN GUI'S DISPLAY:
handles.axes2();
imshow(handles.dim_image, [min(handles.dim_image(:)), max(handles.dim_image(:)) ])

% display the current file index in the file index text-edit
set(handles.edit8, 'string', [num2str(handles.dim_currentFileIdx), '/', num2str(length(handles.dim_files))] );

%%
% Check the selected folder for existence of annotations.mat
annotationExists = exist([handles.dim_folder, 'annotations.mat'], 'file'); % 2 = yes, 0 = no

% if annotation exists, load the annotation
if (annotationExists == 2)
    load ([handles.dim_folder, 'annotations.mat']);
    handles.annotations = annotations;
    guidata(hObject, handles);
    % do other things
else
    % create annotations
    annotations = handles.annotations;
    save([handles.dim_folder, 'annotations.mat'], 'annotations');
end

%%
show_annotations_for_current_folder
