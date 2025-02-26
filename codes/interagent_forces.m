function force = interagent_forces(agent, neighbors, positions, velocities, is_leader)
global w_leader C_align C_attr C_rep rho phi N numAgents 

repulsion = 0;
alignment = 0;
attraction = 0;
for j =1:numAgents
    if agent ~= j 
        repulsion = repulsion - C_rep*rho(positions(j, :)-positions(agent, :));
    end
end

for k = 1:N
    j = neighbors(k);
    if agent ~= j 
        %F_ij = C_align/N*(velocities(j,:)-velocities(agent,:));
        G_ij = C_attr*phi(positions(j, :)-positions(agent, :));
        % Amplify force if `j` is a leader
        if is_leader(j)
            %alignment = alignment + w_leader * F_ij;
            attraction = attraction + w_leader * G_ij;
        else
            %alignment = alignment + F_ij;
            attraction = attraction + G_ij;
        end
    end
end
force = repulsion + attraction; %+ alignment;