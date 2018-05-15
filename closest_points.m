%returns the indices of the closest five points.
function index_array = closest_points(distance_array)
    %disp('calling closest points');
    [B, IX] = sort(distance_array);
    index_array = IX;
end