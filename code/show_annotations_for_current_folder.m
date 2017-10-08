% load the annotations.mat from the current folder
annotations = handles.annotations;


% show all annotations for the current slice
% for each annotation
textcomposition = {};
ancounter = 1;
for nannotation = 1:length(annotations)
    % get value of its nslice field
    ann = annotations{nannotation};
    nslice = ann.nslice;
    
    % if this field is the same as the current slice being viewed, display
    % the vertices field
    if (nslice == handles.dim_currentFileIdx)
        vertices = ann.vertices;
       
        handles.axes2(); hold on;
        scatter(vertices(:,1), vertices(:,2), '.', 'g');
        plot(vertices(:,1), vertices(:,2), 'y');
        hold on;
        text('Position', round(mean(vertices)), 'string', ['A', num2str(ancounter)], 'color', 'r', 'fontsize', 15);
        
        textcomposition{end+1} = [' Annotation ', num2str(ancounter), ' : ', ann.name];
        ancounter = ancounter + 1;
    end
end

% update the display of annotations for current page
set(handles.edit9, 'string', textcomposition);
