set(handles.pushbutton2, 'string', 'Anonymizing and Saving ...');
pause(1e-6);

% create anonymized folder if it does not exist
if (~ isdir('anonymized'))
    mkdir anonymized
end

% get the anonymous name, id and DOB from corresponding text edits
an_name = get(handles.edit1, 'string');
an_id = get(handles.edit2, 'string');
an_dob = get(handles.edit3, 'string');

% for each file in the handles.dim_files
for nfile = 1:length(handles.dim_files)
    % read corresponding DICOM info
    dinfo = dicominfo([handles.dim_folder, handles.dim_files(nfile).name]);
    
    % erase fields PatientName, PatientID, and BirthDate
    dinfo.PatientName.GivenName = 'AN';
    dinfo.PatientName.FamilyName = an_name;
    dinfo.PatientID = an_id;
    dinfo.PatientBirthDate = an_dob;
    
    % read corresponding DICOM image
    dimage = dicomread([handles.dim_folder, handles.dim_files(nfile).name]);
    
    % write image and corresponding info to 'anonymized' subfolder
    dicomwrite(dimage, ['anonymized\', handles.dim_files(nfile).name], dinfo);
end

set(handles.pushbutton2, 'string', 'Anonymize and Save');
pause(1e-6);

%%
set(handles.edit8, 'string', num2str(1));

%switch to anonymized folder
handles.dim_folder = 'anonymized\';
handles.dim_files = dir(['anonymized\', 'Im', '*']);
handles.dim_currentFileIdx = 1;

guidata(hObject, handles);

% READ THE FIRST DICOM IMAGE IN THE IMAGE CONTAINING FOLDER
handles.dim_image = dicomread([handles.dim_folder, handles.dim_files(1).name]);
guidata(hObject, handles);

% SET THE SLIDER POSITION TO POSITION OF FIRST IMAGE IN THE DATABSE
set(handles.slider1, 'min', 1); 
set(handles.slider1, 'max', length(handles.dim_files));
set(handles.slider1, 'value', 1);
set(handles.slider1, 'SliderStep', [1/(length(handles.dim_files) - 1), 1/(length(handles.dim_files) - 1)] );

% READ THE METADATA ASSOCIATED WITH THE FILENAME
handles.dim_info = dicominfo([handles.dim_folder, handles.dim_files(1).name]);
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