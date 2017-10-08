% Plot all vertices created from all annotation vertices on the current
% page
clear v
% create figure
plot3d = 10;
figure(plot3d);
title('3D from propagation of annotations');
hold on;

vertextrack = [];

% get extract all propagated vertices from cell 'allvertices'
for nvertex = 1:length(allvertices)
    vertex = allvertices{nvertex};
    
    if (size(vertex, 1) > 1)
        % multiply y-coordinates with -1 so that display of 3d and display
        % on main gui are oriented the same way
        vertextrack(:,:,end+1) = [vertex];
    end
end

save('vertextrack.mat', 'vertextrack');
%%
% create isosurface from propagated vertices

vertextrack = vertextrack(:,:,2:end);
nlayers = size(vertextrack, 3);

% create meshgrid x, y, z
width = size(handles.dim_image, 2);
height = size(handles.dim_image, 1);
[x, y, z] = meshgrid(1:width, 1:height, linspace(1, max(40, nlayers), nlayers));
isovalue = -5;

v = [];

% for each layer, the number of which is evident in x, y, and z
for nlayer = 1:nlayers
    % get corresponding vertex locations
    vertices = vertextrack(:,:,nlayer);
    vertices = vertices(:,1:2);
    
    % interpolate vertices to get a dense plot
    vertices = vertices(:,1:2);
    for ninterpolations = 1:10
        vertices = interp2(vertices);
        vertices = [vertices(:,1), vertices(:,3)];
    end
    nlocations = size(vertices, 1);
    vlayer = zeros(height, width);
    % at each vertex location
    for nlocation = 1:nlocations
        % set value to isovalue
        location = round(vertices(nlocation,:));
        vlayer(width - location(1), height - location(2)) = isovalue;
    %endfor;
    end

    % try to fill holes
    gaussianfilter = fspecial('gaussian');
    vlayer = imfilter(vlayer, gaussianfilter);
    vlayer(vlayer ~= 0) = isovalue;
    
    
    v(:,:,nlayer) = vlayer;
%endfor
end

%%
% plot isosurface
p = patch(isosurface(x,y,z,v, isovalue));
% isonormals(x,y,z,v,p)
% p.FaceColor = colors(ancounter,:);
% p.EdgeColor = 'none';
% daspect([1 1 1])
% view(3); 
% axis tight
% camlight 
% lighting gouraud
isonormals(x,y,z,v,p)
set(p,'FaceColor',colors(ancounter,:),'EdgeColor','none');
daspect([1 1 1])
view(2); axis tight
camlight 
lighting gouraud
alpha(0.7)

figure(10)
hold on;
