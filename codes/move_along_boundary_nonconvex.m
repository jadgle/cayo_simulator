function new_pos = move_along_boundary_nonconvex(new_pos)
    global boundary_points
    % finding closest vertex
    distances = vecnorm(boundary_points - new_pos, 2, 2);
    [~, closest_vertex_idx] = min(distances);
    
    %%
    num_vertices = length(boundary_points);
    
    % Define forward (+1) and backward (-1) edges
    forward_idx = mod(closest_vertex_idx, num_vertices) + 1;
    backward_idx = mod(closest_vertex_idx-2, num_vertices) + 1;
    
    % Edge endpoints
    edge_fwd_start = boundary_points(closest_vertex_idx,:);
    edge_fwd_end   = boundary_points(forward_idx,:);
    
    edge_bwd_start =  boundary_points(closest_vertex_idx,:);
    edge_bwd_end   =  boundary_points(backward_idx,:);
    
    % Project position onto both edges
    proj_fwd = project_point_on_segment(new_pos, edge_fwd_start, edge_fwd_end);
    proj_bwd = project_point_on_segment(new_pos, edge_bwd_start, edge_bwd_end);
    
    % Compute distances
    dist_fwd = norm(proj_fwd - new_pos);
    dist_bwd = norm(proj_bwd - new_pos);
    
    % Choose the closest edge
    if dist_fwd < dist_bwd
        %plot([edge_fwd_start(1), edge_fwd_end(1)],[edge_fwd_start(2), edge_fwd_end(2)], 'g-', 'LineWidth', 2)
        new_pos = proj_fwd;
    else
        %plot([edge_bwd_start(1), edge_bwd_end(1)],[edge_bwd_start(2), edge_bwd_end(2)], 'c-', 'LineWidth', 2)
        new_pos = proj_bwd;
    end
    


end
