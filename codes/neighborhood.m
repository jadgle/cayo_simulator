function neighbors = neighborhood(positions,agent,is_leader,N)
% `neighbors` contains the N closest, with the closest leader guaranteed
distances = vecnorm(positions - positions(agent,:), 2, 2);

% Find the indices of agents sorted by distance (excluding itself)
[~, sorted_indices] = sort(distances);
sorted_indices(sorted_indices == agent) = []; % Exclude the agent itself

% Select N closest agents
neighbors = sorted_indices(1:N);

% Check if a leader is among the neighbors
% leader_indices = find(is_leader); % Find indices of all leaders
% leader_distances = distances(leader_indices); % Get distances to leaders
% [~, min_leader_idx] = min(leader_distances); % Find closest leader
% closest_leader = leader_indices(min_leader_idx); % Index of closest leader
% 
% % Ensure closest leader is among the neighbors
% if (~ismember(closest_leader, neighbors) && ~is_leader(agent))
%     neighbors(end) = closest_leader; % Replace the farthest neighbor with the closest leader
% end