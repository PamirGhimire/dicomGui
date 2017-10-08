% enable free hand draw
handles.axes2();
h = imfreehand;

% retrieve annotation's vertices from free hand draw
annvertices = getPosition(h);
delete(h);

% display the annotation on image
hold on;
scatter(annvertices(:,1), annvertices(:,2), '.', 'g');

% ask user to save annotation
wantAnnotation = questdlg('Save this annotation?');

if (strcmp(wantAnnotation, 'Yes') == 1)
    aname = inputdlg('Enter Annotation Name:');
    
    % add the annotations to the list of annotations
    ann = struct('nslice', handles.dim_currentFileIdx, 'vertices', annvertices, 'name', aname);

    handles.annotations{end+1} = ann;
    guidata(hObject, handles);

    % write updated annotations for the current folder to disk
    annotations = handles.annotations;
    save([handles.dim_folder, 'annotations.mat'], 'annotations');

end

%%

show_annotations_for_current_folder;

