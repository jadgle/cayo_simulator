function force = hurricane_repulsion(agent, positions, center_x, center_y,U,V,wind_power_at_agent,hurricane_direction)
global k_tornado dx dy x_min y_min wind_power_threshold movement_scaling_factor

% Compute repulsion force from tornado
r_i_tornado = positions(agent, :) - [center_x, center_y];
distance_to_tornado = norm(r_i_tornado);

% Tornado repulsion force (inverse-square law)
if distance_to_tornado > 0  % Avoid division by zero
    F_tornado = k_tornado * (r_i_tornado / distance_to_tornado^3);
else
    F_tornado = [0, 0];  % No repulsion if exactly at the center (unlikely scenario)
end

% Get wind vector at agent's position

x_idx = round((positions(agent, 1) - x_min) / dx) + 1;
y_idx = round((positions(agent, 2) - y_min) / dy) + 1;
wind_vector = [U(x_idx, y_idx), V(x_idx, y_idx)];


% Apply enhanced repulsion force if wind power at the agent's position is above threshold
if wind_power_at_agent > wind_power_threshold
    % Rotate the wind vector by 90 degrees to get the perpendicular direction
    perpendicular_direction = [-wind_vector(2), wind_vector(1)]; % Rotate 90 degrees counterclockwise
    perpendicular_direction = perpendicular_direction / norm(perpendicular_direction); % Normalize
else
    % No wind vector, no perpendicular direction (stay still)
    perpendicular_direction = [0, 0];
end

% The hurricane_direction is a vector (e.g., [1, 0] for eastward movement)
    
    % Cross product between the wind direction and hurricane direction
    wind_cross_hurricane = cross([wind_vector, 0], [hurricane_direction, 0]);

    if wind_cross_hurricane > 0
        % Wind is coming from the left (hurricane receding), move toward the wind
        movement_direction = movement_scaling_factor * wind_power_at_agent *perpendicular_direction; % Move with the wind
    else
        % Wind is coming from the right (hurricane approaching), move away from the wind
        movement_direction = movement_scaling_factor * wind_power_at_agent *(-perpendicular_direction); % Move away from the wind
    end

force = F_tornado + movement_direction;
end