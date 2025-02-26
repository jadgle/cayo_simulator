
clear all
close all
clc
rng(0)

global w_leader C_align C_attr C_rep rho phi N numAgents k_tornado dx dy x_min x_max y_min y_max wind_power_threshold movement_scaling_factor boundary_points

%% Building the domain
domain_polygon = domain('Cayo_Santiago.kml');
[shiftx,shifty] = centroid(domain_polygon);  % Get the centroid [x, y]
% Shift the polygon's vertices by subtracting the centroid coordinates
domain_polygon.Vertices(:, 1) = domain_polygon.Vertices(:, 1) - shiftx;
domain_polygon.Vertices(:, 2) = domain_polygon.Vertices(:, 2) - shifty;

% use this if you want a simulation on a box
%boundary = domain([0, 1000, 1000, 0; 0, 0, 1000, 1000]');  

%% Building the grid for the windfield
grid_resolution = 50; % Adjust for desired resolution

vertices = domain_polygon.Vertices;
x_min = min(vertices(:, 1))-5;
x_max = max(vertices(:, 1))+5;
y_min = min(vertices(:, 2))-5;
y_max = max(vertices(:, 2))+5;

[X, Y] = meshgrid(linspace(x_min, x_max, grid_resolution), linspace(y_min, y_max, grid_resolution));

dx = (x_max - x_min) / (grid_resolution - 1);
dy = (y_max - y_min) / (grid_resolution - 1);

[x_boundary, y_boundary] = boundary(domain_polygon);
% Convert to an Nx2 matrix for easier computations
boundary_points = [x_boundary, y_boundary];

f = figure('visible','off');
aspect_ratio = 680 / 800; % Match Google Earth pictures aspect ratio
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultLegendInterpreter','latex')
set(0,'DefaultAxesTickLabelInterpreter','latex')
set(0,'DefaultLegendFontSize',18)
set(0,'DefaultTextFontSize',18)
set(0,'DefaultAxesFontSize',18)
set(0,'DefaultLineLineWidth',1.2);
set(gcf,'color','w');
set(gcf,'defaultAxesXGrid','on')
set(gcf,'defaultAxesYGrid','on')
set(gcf,'defaultAxesZGrid','on')
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
xlim([x_min x_max]);
ylim([y_min y_max])
% Adjust figure size
set(f, 'Units', 'pixels', 'Position', [100, 100, 800, 800 * aspect_ratio]); 
axis equal; % Ensure correct scaling
axis off;
ImageFolder ='your_folder';
name = 'simulation';

%% Tornado parameters

% Center movement parameters
amplitude = 6;  % Amplitude of the tornado center's sine wave motion
frequency = .75;  % Frequency of the sine wave
vertical_speed = 4;  % Vertical speed of the tornado center

% Enhancement factor parameters
max_wind_strength = 55.0; % maximum wind strength near the center
R_scale = 250; % scale factor for wind strength decay
k_tornado = 10;  % Tornado repulsion strength

% Wind danger threshold (above this value, agents die)
deathly_wind = 30.0;

% Noise parameters (for wind field)
noise_level = 0.5;
trajectory_noise_level = 0.05;

%% Agents parameters
numAgents = 1000;
numLeaders = 0;
N = 5; % Number of closest neighbors to consider for each agent

C_rep = 2.5;  % constant for repulsion
C_align = .0001; % constant for alignment
C_attr = .71; %constant for attraction

r = 2.5;
gamma = 2;
rho = @(diff) exp(-diff.^gamma) .* diff ./ (abs(diff) + 1e-15) .* (diff <= r);
phi = @(diff) diff.*(diff>r);



%% Sampling agents

% Initialize arrays to track dead agents
dead_agents_positions = [];

positions = zeros(numAgents, 2);
% Agent initialization: sample agents within the polygonal domain
count = 0; % Counter for accepted agents
while count < numAgents
    % Generate random points within the bounding box
    randX = x_min + (x_max - x_min) * rand;
    randY = y_min + (y_max - y_min) * rand;

    % Check if the point is inside the domain
    if isinterior(domain_polygon, randX, randY)
        count = count + 1; 
        positions(count,:) = [randX,randY];
    end
end

velocities = zeros(numAgents, 2); 
agents_alive = true(numAgents, 1);

leader_indices = 1:numLeaders; % leaders with anticipation
follower_indices = setdiff(1:numAgents, leader_indices); % All other agents are followers
w_leader = 10;  % Strength of the leader-following force
% Logical array to track if an agent is a leader
is_leader = false(numAgents, 1);
is_leader(leader_indices) = true;


% Maximum speed limit (monkey speed)
max_speed = 4; % meters per second

% Wind power threshold for triggering escape at agent's position
wind_power_threshold = 5; % Adjust this value based on what is considered "dangerous" at the agent's position

% Perpendicular movement scaling factor
movement_scaling_factor = 1; % Controls how strongly agents move perpendicular to wind field

% Anticipation interval parameters
delta_t_anticip = 50;    % Length of anticipation interval in time
n_anticip_steps = 100;     % Number of steps to approximate the integral
beta = 0;                  % Decay rate for the weight function

%% time integration
dt = .5;
nSteps = 200;

center_x = (x_min + 5*x_max) / 6;  % Initialize center_x to be in the middle horizontally
center_y = y_min -100 + trajectory_noise_level * randn;  % Move center_y slightly below the bottom of the polygon with noise

x = zeros(numAgents, 2, nSteps+1); 
x(:,:,1) = positions;

tic
% Time loop
for step = 2:nSteps+1
    % hurricane dynamics
    future_center_x = center_x - amplitude * sin(frequency * dt) + trajectory_noise_level * randn; % Horizontal position
    future_center_y = center_y + vertical_speed * dt + trajectory_noise_level * randn; % Vertical position
    % Initialize the integral of the tornado's future position (for anticipation)
    weighted_integral_tornado_position = [0, 0];
    total_weight = 0;

    % If you know the center's velocity, you can compute the direction
    dx_center = future_center_x - center_x;  % Change in x-coordinate of the center
    dy_center = future_center_y - center_y;  % Change in y-coordinate of the center
    hurricane_direction = [dx_center, dy_center];  % Direction of movement of the center
    hurricane_direction = hurricane_direction / norm(hurricane_direction);  % Normalize

    center_x = future_center_x;
    center_y = future_center_y;
    % Discretize the integral as a weighted sum over future time steps
    for future_step = 1:n_anticip_steps  
        % Weight function (exponential decay)
        weight = exp(-beta * future_step * (delta_t_anticip / n_anticip_steps));
    
        % Predict tornado future position based on initial position
        future_center_x = future_center_x - amplitude * sin(frequency * delta_t_anticip) + trajectory_noise_level * randn;
        future_center_y = future_center_y + vertical_speed * delta_t_anticip + trajectory_noise_level * randn;
    
        % Accumulate the weighted sum for integral approximation
        weighted_integral_tornado_position = weighted_integral_tornado_position + weight * [future_center_x, future_center_y];
    
        % Keep track of total weights for normalization
        total_weight = total_weight + weight;
    end


    % Normalize by the sum of weights
    weighted_integral_tornado_position = weighted_integral_tornado_position / total_weight;
    
    % Define the radial distance from the center
    R = sqrt((X - center_x).^2 + (Y - center_y).^2); % radial distance from center

    % Enhancement function: stronger wind near the center, weaker farther away
    Enhancement = max_wind_strength * exp(-R / R_scale);

    % Define the spiral wind field with noise
    Theta = atan2(Y - center_y, X - center_x); % angle w.r.t. center
    U = -Enhancement .* sin(Theta) + noise_level * randn(size(X)); % x-component with noise
    V = Enhancement .* cos(Theta) + noise_level * randn(size(Y)); % y-component with noise

    % Calculate wind power (magnitude of the wind vector)
    WindPower = sqrt(U.^2 + V.^2);

    % Interpolate wind power at each agent's position
    wind_power_at_agents = griddata(X, Y, WindPower, positions(:,1), positions(:,2), 'linear');

    % List to keep track of agents to remove
    agents_to_remove = [];

    %%
    % Compute forces and update positions and velocities
    for i = 1:numAgents
        if agents_alive(i) % Only update alive agents

            % check if the agent is still alive
            wind_power_at_agent = wind_power_at_agents(i);
            if wind_power_at_agent >= deathly_wind
                agents_alive(i) = false; % If wind power is too high, the agent "dies" 
                dead_agents_positions = [dead_agents_positions; positions(i, :)]; % Store position of dead agent
                agents_to_remove = [agents_to_remove; i];

            else % compute all forces acting on the alive agents
                neighbors = neighborhood(positions,i,is_leader,N);

                interaction = interagent_forces(i, neighbors, positions, velocities,is_leader); % interagent forces 
                wind_repulsion = hurricane_repulsion(i, positions, center_x, center_y,U,V,wind_power_at_agent,hurricane_direction); % hurricane repulsion (centre + wind fear)
                anticipation = anticipation_force(i, positions,weighted_integral_tornado_position,is_leader); % Anticipation Force (Only for leaders)

                total_force = interaction + wind_repulsion + anticipation;

                % update velocities and positions
                velocities(i, :) = velocities(i, :) + total_force * dt;
                speed = norm(velocities(i, :));
                if speed > max_speed
                    velocities(i, :) = (velocities(i, :) / speed) * max_speed; % Limit speed
                end
                 new_position = positions(i, :) + velocities(i, :) * dt;
                 if isinterior(domain_polygon, new_position(1), new_position(2)) || inpolygon(new_position(1), new_position(2), x_boundary, y_boundary) || min(vecnorm([x_boundary, y_boundary] - new_position)) < 1e-2
                     positions(i, :) = new_position;
                 else
                     new_position = move_along_boundary_nonconvex(new_position);
                     velocities(i,:) = (new_position-positions(i, :))/dt;
                     positions(i, :) = new_position;
                 end
                 x(i,:,step) = positions(i,:);
            end

            if ~isfinite(positions(i,1)) || ~isfinite(positions(i,2))
                error('Agent position contains invalid values: [%f, %f]', positions(i,1), positions(i,2));
            end
        end
    end

    % Remove dead agents
    if ~isempty(agents_to_remove)
        positions(agents_to_remove, :) = [];
        velocities(agents_to_remove, :) = [];
        is_leader(agents_to_remove) = [];
        numAgents = numAgents - length(agents_to_remove);
        agents_alive = true(numAgents, 1);
    end

    % plotting
    pcolor(X, Y, WindPower);  % Plot wind power as a color map
    hold on
    shading interp; 
    colormap("turbo");
    
    plot(domain_polygon, 'FaceColor', [0.7 0.7 0.7], 'FaceAlpha', 0.5);
    
    % Plot the moving center
    plot(center_x, center_y, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
    
    % Plot agents
    leader_indices = find(is_leader);
    non_leader_indices = find(~is_leader);
    
    plot(positions(non_leader_indices,1), positions(non_leader_indices,2), 'bo', 'MarkerSize', 1, 'MarkerFaceColor', 'b');
    plot(positions(leader_indices,1), positions(leader_indices,2), 'p', 'MarkerSize', 1, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
    
    % Plot dead agents as white crosses
    if ~isempty(dead_agents_positions)
        plot(dead_agents_positions(:, 1), dead_agents_positions(:, 2), 'wx', 'MarkerSize', 8, 'LineWidth', 2);
    end
    xticks([]); % Remove x-ticks
    yticks([]); % Remove y-ticks
    file_name = sprintf([name,'%d.png'], step);
    saveas(f,strcat(ImageFolder,file_name))
    hold off
  

end


