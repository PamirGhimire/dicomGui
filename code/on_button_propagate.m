% get limits for forward and backward propagation using dialogue with the
% user
limits = inputdlg({['forward propagation until slice:'], ['backward propagation until slice:']});
forwardlimit = str2num(cell2mat(limits(1)));
backwardlimit = str2num(cell2mat(limits(2)));

% collect all vertices corresponding to the current page in the same array
vertices = [];
clear v

annotationsFig = 5;
figure(annotationsFig);
colors = colormap(lines(20));

waitMessageBox = waitbar(0.5, 'Processing annotations, please wait!');
% for each annotation in the handle's annotation field
ancounter = 1;
for nannotation = 1:length(handles.annotations)
    % get nslice field
    ann = handles.annotations{nannotation};
    nslice = ann.nslice;
    
    % check whether it is the same as currentFileIdx
    if (nslice == handles.dim_currentFileIdx)
        % if yes, get its 
        ann.vertices(:,2) = ann.vertices(:,2);
        vertices = [ann.vertices];
        
        % scatter the vertices on annotationsFig
        figure(annotationsFig);
        plot(ann.vertices(:,1), -ann.vertices(:,2), 'color', colors(ancounter,:), 'linewidth', 5);
        hold on;
        
        % calculate area encolsed by polygon defined by the vertices
        area = polyarea(ann.vertices(:,1), ann.vertices(:,2)) * handles.dim_info.PixelSpacing(1) * handles.dim_info.PixelSpacing(2);
        volume = area * (forwardlimit - backwardlimit) * handles.dim_info.SliceThickness;
        
        % display area and volume
        areastr = ['Area = ', num2str(area), ' mm^2'];
        volstr = ['Volume = ', num2str(volume), ' mm^3'];
        
        textpos = mean([ann.vertices(:,1), -ann.vertices(:,2)]);
        text('Position', textpos, 'string', areastr, 'backgroundcolor', colors(ancounter,:), 'color', 'k');
        text('Position', textpos + [0, 3], 'string', volstr, 'backgroundcolor', colors(ancounter,:), 'color', 'k');
        
        % update area-volume figure
        figure(annotationsFig);
        title('All annotation vertices on the current page');
    
        % Propagate vertices
        vertices_original = vertices;
        %%
        % initialize array that is to contain the 'point cloud'
        % made of all propagated vertices
        allvertices{handles.dim_currentFileIdx} = vertices_original;
    
        % Propagate contour forward and backward:
        % Propagate forward
        firstimage = handles.dim_currentFileIdx;
        for nimage = (firstimage + 1):forwardlimit-1
            % read base image(im1) and target image (im2)
            im1 = dicomread([handles.dim_folder, handles.dim_files(nimage - 1).name]);
            im2 = dicomread([handles.dim_folder, handles.dim_files(nimage).name]);
        
            % propagate vertices from base to target
            pvertices = propagateVertices(vertices, im1, im2, 4);
            allvertices{nimage} = pvertices;
        
            % now update
            vertices = pvertices;
    end
    %%
        % Propagate backward
        vertices = vertices_original;
    
        for nimage = firstimage:-1:backwardlimit+1
        
            im1 = dicomread([handles.dim_folder, handles.dim_files(nimage).name]);
            im2 = dicomread([handles.dim_folder, handles.dim_files(nimage-1).name]);
        
            % propagate vertices of im1 to im2
            pvertices = propagateVertices(vertices, im1, im2, 4);
            allvertices{nimage-1} = pvertices;
        
            % now update
            vertices = pvertices;
        end
    
    
    % generate 3D
    plotAllVertices;
    
    ancounter = ancounter + 1;
    end
end
%%
delete(waitMessageBox);
