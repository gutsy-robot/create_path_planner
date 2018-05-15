function isIntersect = check_intersect(obstacles, num_obstacles, x1, y1, x2, y2)
    isIntersect = false;
    x1_vector = [x1, x2];
    y1_vector = [y1, y2];
    for i = 1:num_obstacles
        x2_vector = [obstacles(i,1), obstacles(i,3)];
        y2_vector = [obstacles(i,2), obstacles(i,4)];
        if isempty(polyxpoly(x1_vector, y1_vector, x2_vector, y2_vector)) ~= true
            %disp('intersecting lines..');
            isIntersect = true;
            return;
        else
            %disp('not intersecting obstacles...');
        end
        
    end
end
            