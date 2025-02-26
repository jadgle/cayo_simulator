function domain_polygon = domain(vertices)
    % Create a polygonal domain from a KML file or a collection of vertices
    % INPUT:
    %   vertices - Can be a KML file path (string) or a numeric matrix of vertices [x, y] or [lon, lat].
    % OUTPUT:
    %   domain_polygon - A polyshape object representing the domain.
    warning('off', 'MATLAB:polyshape:repairedBySimplify')
    if ischar(vertices) || isstring(vertices) % If vertices is a KML file path
        % Read the KML file
        dom = xmlread(vertices);
        
        % Extract coordinates (this assumes a <coordinates> tag in the KML file)
        coords = dom.getElementsByTagName('coordinates');
        if coords.getLength > 0
            coordStr = char(coords.item(0).getTextContent);
            
            % Split coordinate string into longitude, latitude, and altitude
            coordArray = str2num(coordStr); %#ok<ST2NM>
            coordMatrix = reshape(coordArray, 3, []).'; % Reshape into Nx3 matrix
            
            % Extract longitude and latitude
            lon = coordMatrix(:, 1);
            lat = coordMatrix(:, 2);
        else
            error('No <coordinates> found in the KML file.');
        end
        
        % Project from latitude/longitude to Cartesian coordinates
        proj = projcrs(32619); % UTM Zone 19N (covers Cayo Santiago) -------------------- we need to make this customizable
        [x, y] = projfwd(proj, lat, lon); % Converts lat/lon to Cartesian x/y
        
    else isnumeric(vertices) && size(vertices, 2) >= 2 % If vertices is a numeric matrix
        % Assume vertices are given in Cartesian coordinates or lon/lat directly
        x = vertices(:, 1);
        y = vertices(:, 2);
    end
    
    % Create the polygon domain
    domain_polygon = polyshape(x, y);
end

