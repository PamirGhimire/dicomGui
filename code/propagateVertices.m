function pvertices = propagateVertices(vertices, im1, im2, n)

% propagate vertices from im1 to im2
% propagated to location closest in euclidean sense
%
% By Pamir Ghimire
% pamirghimire <> gmail
% Graduate Student, M1
% Master Computer Vison (MCV)
% Universite De Bourgogne

if (nargin < 4)
    n = 4;
end

mindistance = 1e9;

% for each vertex point
for nvertex = 1:size(vertices, 1)
    v = vertices(nvertex,:);
    
    % get NxN patch in im1
    rows = round(v(2) - n/2);
    rowe = round(v(2) + n/2);
    cols = round(v(1) - n/2);
    cole = round(v(1) + n/2);
    
    patch_im1 = im1(rows:rowe, cols:cole);
    %lbp_im1 = extractLBPFeatures(patch_im1);
    
    % find where to propagate in im2
    mindistance = 1e9;
    proplocation = [0, 0];
    
    for row = rows:rowe
        for col = cols:cole
            rows_im2 = round(row - n/2);
            rowe_im2 = round(row + n/2);
            cols_im2 = round(col - n/2);
            cole_im2 = round(col + n/2);
            
            patch_im2 = im2(rows_im2:rowe_im2, cols_im2:cole_im2);
            %lbp_im2 = extractLBPFeatures(patch_im2);
            
            %distance_patches = sqrt(sum(sum((lbp_im1 - lbp_im2).^2)));
            distance_patches = sqrt(sum(sum((patch_im1 - patch_im2).^2)));
            
        % find the location in neighbourhood in im2 that is most similar
        if (distance_patches < mindistance)
            proplocation = [col, row];
            mindistance = distance_patches;
        end
        end
    end
            
    % propagate the vertex there
    pvertices(nvertex,:) = proplocation;
end


end
