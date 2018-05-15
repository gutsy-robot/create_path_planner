function isIntersect = isIntersecting(obstacles, current_x, current_y , goal_x , goal_y, num_obstacles)
    %disp('function called');
    isIntersect = false;
    %[num_obstacles, n] = size(obstacles);
    a1 = (goal_y - current_y);
    b1 = -1*(goal_x - current_x);
    c1 = (goal_y-current_y)*current_x - (goal_x - current_x)*current_y;
    for i = 1:num_obstacles
                    disp('checking for obstcle number...');
                    disp(i);
                    a2 = (obstacles(i,4) - obstacles(i,2));
                    b2 = -1*(obstacles(i,3) - obstacles(i,1));
                    c2 = (obstacles(i,4) - obstacles(i,2))*obstacles(i,1) - (obstacles(i,3) - obstacles(i,1))*obstacles(i,2);
                %display('this block passed..');
                
                    if a1*b2 ~= b1*a2
                        x = (c1*b2 - c2*b1)/(a1*b2 - a2*b1);
                        y = (c1*a2 - c2*a1)/(b1*a2 - b2*a1);
                        if (x >= min([current_x, goal_x]) && x >= min([obstacles(i,1), obstacles(i,3)])) && (x <= max([current_x, goal_x]) && x <= max([obstacles(i,1), obstacles(i,3)]))
                            if (y >= min([current_y, goal_y]) && y >= min([obstacles(i,2), obstacles(i,4)])) && (y <= max([current_y, goal_y]) && y<= max([obstacles(i,2), obstacles(i,4)]))
                                isIntersect = true;
                                disp('intersecting obstacles at....');
                                disp(x);
                                disp(y);
                                disp('-----------');


                                break;

                            else
                                disp('here....');
                                disp(x);
                                disp(y);
                                disp('value of a2 is:');
                                disp(a2)
                                disp('the value of b2 is');
                                disp(b2);
                                disp('the value of c2 is');
                                disp(c2);
                                disp('miny');
                                disp(min([obstacles(i,2), obstacles(i,4)]));
                                disp('maxy');
                                disp(max([obstacles(i,2), obstacles(i,4)]));
                                disp('miny_again');
                                disp(min([current_y, goal_y]));
                                disp('max_y_again');
                                disp(max([current_y, goal_y]));
                                
                                disp('---------');

                            end
                        else
                            disp('the line under check is');
                            disp([current_x, current_y, goal_x, goal_y]);
                            disp('the obstacled line is');
                            disp([obstacles(i,1), obstacles(i,2), obstacles(i,3), obstacles(i,4)]);
                            disp('the calculated points are');
                            disp(x);
                            disp(y);
                            disp('therefore, not intersecting..');
                            disp('---------------');
                        end
                    elseif a1*b2 == b1*a2 && b1*c2 == b2*c1 && a1*c2 == a2*c1
                        if (current_x > obstacles(1) && current_x > obstacles(3)) && (goal_x > obstacles(1) && goal_x > obstacles(3))
                            isIntersect = false;
                            %disp('block passed');
                        elseif (current_x < obstacles(1) && current_x < obstacles(3)) && (goal_x < obstacles(1) && goal_x < obstacles(3))
                            isIntersect = false;
                            %disp('last block passed');
                        else
                            isIntersect = true;
                            %disp('intersecting obstacles last....');
                            break;

                        end

                    end
           
         

        
        
       
    end
      
   
    
    
        
        