function path_planner(serPort)


    %read the obstacle file into column vector
    obstacle_file = 'map_custom.txt';
    fid = fopen(obstacle_file);
    tline = fgetl(fid);
    tlines = cell(0,1);
    obstacles = zeros(200,4);
    counter = 1;
    %obstacles_raw = {' '};
    while ischar(tline)
        disp(tline);
        tlines{end+1,1} = tline;
        temp = strsplit(tline);
        for i = 1:4
            obstacles(counter,i) = str2double(temp(i+1));
        %obstacles_raw = [ obstacles_raw, tline];

        end
        tline = fgetl(fid);
        counter = counter + 1;

    end
    fclose(fid);

    [num_walls, m] = size(tlines);
    %type conversion
    %temp = char(tlines);


    %parse obstacles_raw
    %obstacles = createObstacles(obstacles_raw);

    %initial co-ordinates
    start_x = 0;
    start_y = 0;

    %goal co-ordinates
    goal_x = 10;
    goal_y = 10;

    %initial inclination with x-axis
    

    %total number of points including goal
    total_points = 500 ;

    %generate random x and y co-ordinates
    random_x = (10-0).*rand((total_points -1) ,1) + 0;
    random_y = (10-0).*rand((total_points -1) ,1) + 0;

    random_x = [random_x; goal_x];
    random_y = [random_y; goal_y];



    %stack which stores the visited point indices.
    visited_points_stack =java.util.Stack();
    visited_points_stack.push(0);

    %stores whether a particular point has been traversed by the robot.
    visited_array = false(total_points,1);

    %the point where the robot initially is, zero corresponds to start point.
    current_point_index = 0;


    %most feasible points to move.
    current_cost_array = cost_calculator(current_point_index, random_x, random_y, start_x, start_y, goal_x, goal_y, total_points);

    %array which stores the indices in order of closeness to the current point.
    closest_points_indices = closest_points(current_cost_array);

    %plot the initial step.
    h1 = figure('Name','a* graph search');
    scatter(start_x,start_y,'o');
    figure(h1);
    ax = gca; hold on;
    scatter(goal_x,goal_y,'o');


    %plot obstacles.
    for j = 1:num_walls
        plot(ax, [obstacles(j,1) obstacles(j,3)], [obstacles(j,2) obstacles(j,4)], 'black');
    end
    %plot points and connections
    scatter(ax, random_x, random_y, 'r');
    %plot(ax, [0 random_x(closest_points_indices(1))], [ 0 random_y(closest_points_indices(1))], 'blue');

    t = 1;
    while check_intersect(obstacles,num_walls, 0, 0, random_x(closest_points_indices(t)), random_y(closest_points_indices(t))) == true
        t = t +1;
    end

    plot(ax, [0 random_x(closest_points_indices(t))], [ 0 random_y(closest_points_indices(t))], 'blue');
    current_point_index = closest_points_indices(t);
    visited_points_stack.push(closest_points_indices(t));
    visited_array(closest_points_indices(t)) = true;
    %isIntersecting(obstacles, random_x(current_point_index), random_y(current_point_index) , random_x(closest_points_indices(counter)), random_y(closest_points_indices(counter)));

    %loop until we reach the goal.
    while random_x(current_point_index) ~= goal_x || random_y(current_point_index) ~= goal_y

        counter = 2;
        current_cost_array = cost_calculator(current_point_index, random_x, random_y, start_x, start_y, goal_x, goal_y, total_points);
        closest_points_indices = closest_points(current_cost_array);
        %isIntersecting(obstacles, random_x(current_point_index), random_y(current_point_index) , random_x(closest_points_indices(counter)), random_y(closest_points_indices(counter)));
        while visited_array(closest_points_indices(counter)) == true  || check_intersect(obstacles, num_walls, random_x(current_point_index), random_y(current_point_index) , random_x(closest_points_indices(counter)), random_y(closest_points_indices(counter))) == true
            if counter >= total_points
                disp('no path found, replanning....');
                disp(counter);
                visited_points_stack.pop();
                visited_array(current_point_index) = true;
                current_point_index = visited_points_stack.pop();
                if current_point_index ~= 0
                    visited_points_stack.push(current_point_index);
                    current_cost_array = cost_calculator(current_point_index, random_x, random_y, start_x, start_y, goal_x, goal_y, total_points);
                    closest_points_indices = closest_points(current_cost_array);
                    counter = 3;
                else
                    disp('no path found, terminating');
                    return;
                end
            else

                counter = counter + 1;
            end



        end
        %disp(counter);
        plot(ax, [random_x(current_point_index) random_x(closest_points_indices(counter))], [ random_y(current_point_index) random_y(closest_points_indices(counter))], 'blue');
        pause on;
        pause(0.5);
        current_point_index = closest_points_indices(counter);
        visited_points_stack.push(closest_points_indices(counter));
        visited_array(closest_points_indices(counter)) = true;
    end
     l = size(visited_points_stack);
     disp('l is');
     disp(l);
     %for j = 1:l
      %  plot(ax, [random_x(visited_points_stack(j)) random_x(visited_points_stack(j+1))], [random_y(visited_points_stack(j)) random_y(visited_points_stack(j+1))], 'red');
    %end
    
    
    disp('executing path now...');
    curr_x = 0.0;
    curr_y = 0.0;
    thetha = 0;
    path = java.util.Stack();
    path_plot_x = zeros(l,1);
    path_plot_y = zeros(l,1);
    count = 1;
    while size(visited_points_stack) >=2
        temp = visited_points_stack.pop();
        path.push(temp);
        path_plot_x(count) = random_x(temp);
        path_plot_y(count) = random_y(temp);

        count = count + 1 ;
    end
    h2 = figure('Name','actual robot path');
    plot(path_plot_x,path_plot_y, 'red');
    figure(h2);

    while size(path) >= 1
        disp('index is..');
        index = path.pop();
        disp(index);
        x = random_x(index);
        y = random_y(index);
        alpha = atand(abs((y-curr_y)/(x-curr_x)));
        if (x-curr_x) >=0 && (y-curr_y) >= 0
            thetha = alpha - thetha;
        elseif (x-curr_x) >=0 && (y-curr_y) <= 0
            thetha = (360-alpha) - thetha;
        elseif (x-curr_x) < 0 && (y-curr_y) >= 0
            thetha = (180-alpha) - thetha;
        elseif (x-curr_x) < 0 && (y-curr_y) < 0
            thetha = (180+alpha) - thetha;
        end
            
        turnAngle(serPort, .2, thetha);
        disp('turnung thetha...');
        travelDist(serPort, .1, sqrt((y-curr_y)*(y-curr_y)+(x-curr_x)*(x-curr_x)));
        [x_actual y_actual th]= OverheadLocalizationCreate(serPort);
        if th< 0
            th = 360 - abs(radtodeg(th));
        else
            th = radtodeg(th);
        end
        
        beta = atand(abs((y-y_actual)/(x-x_actual)));
        
        if (x-x_actual) >=0 && (y-y_actual) >= 0
            th = beta - th;
        elseif (x-x_actual) >=0 && (y-y_actual) <= 0
            th = (360-beta) - th;
        elseif (x-x_actual) < 0 && (y-y_actual) >= 0
            th = (180-beta) - th;
        elseif (x-x_actual) < 0 && (y-y_actual) < 0
            th = (180+beta) - th;
        end
        %plot(ax, [x curr_x], [y curr_y], 'blue');
        turnAngle(serPort, .2, th);
        travelDist(serPort, .1, sqrt((y-y_actual)*(y-y_actual)+(x-x_actual)*(x-x_actual)));
        curr_x = x;
        curr_y = y;
        [x_new y_new th2]= OverheadLocalizationCreate(serPort);
        thetha = th2;
        if thetha< 0
            thetha = 360 - abs(radtodeg(th2));
        else
            thetha = radtodeg(th2);
        end
        
    end
end






%current_distance_array = zeros(100,1);
%point_index = 1;
% calculates distance between points
    
