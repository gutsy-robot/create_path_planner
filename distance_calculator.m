%calculates distance of all the points from the current point.

function distance_array = distance_calculator(point_index, random_x, random_y, start_x, start_y)
distance_array = zeros(100,1);   
      for c = 1:100
           if point_index ~= 0
                distance_array(c) = sqrt((random_x(point_index) - random_x(c))*(random_x(point_index) - random_x(c)) + (random_y(point_index) - random_y(c))*(random_y(point_index) - random_y(c)));
           else
                distance_array(c) = sqrt((start_x - random_x(c))*(start_x - random_x(c)) + (start_y - random_y(c))*(start_y - random_y(c)));
            end
       end
end
        