function force = anticipation_force(agent, positions,weighted_integral_tornado_position,is_leader)

global k_tornado
force = 0; % Anticipation Force (Only for leaders)
if is_leader(agent)
    % Anticipation force based on future tornado position
    r_i_future_tornado = positions(agent, :) - weighted_integral_tornado_position;
    distance_to_future_tornado = norm(r_i_future_tornado);
    force = k_tornado * (r_i_future_tornado / distance_to_future_tornado^3);
end