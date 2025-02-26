function result = project_point_on_segment(p,a,b)
ap = p-a;
ab = b-a;
% Compute t (projection scalar)
t = dot(ap, ab) / dot(ab, ab);

% Clamp t to stay within [0,1]
t = max(0, min(1, t));
result = a+t*ab;
end