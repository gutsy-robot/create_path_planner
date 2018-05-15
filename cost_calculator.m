%calculates distance of all the points from the current point.

function cost_array = cost_calculator(point_index, random_x, random_y, start_x, start_y, goal_x, goal_y, num_points)
disp('calling cost calculator');
cost_array = zeros(num_points,1);   
      for c = 1:num_points
           if point_index ~= 0
                cost_array(c) = sqrt((random_x(point_index) - random_x(c))*(random_x(point_index) - random_x(c)) + (random_y(point_index) - random_y(c))*(random_y(point_index) - random_y(c))) + sqrt((goal_x - random_x(c))*(goal_x - random_x(c)) + (goal_y - random_y(c))*(goal_y - random_y(c)));
           else
                cost_array(c) = sqrt((start_x - random_x(c))*(start_x - random_x(c)) + (start_y - random_y(c))*(start_y - random_y(c))) + sqrt((goal_x - random_x(c))*(goal_x - random_x(c)) + (goal_y - random_y(c))*(goal_y - random_y(c)));
            end
       end
end
        