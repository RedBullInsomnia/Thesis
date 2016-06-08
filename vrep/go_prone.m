function inst = go_prone(h, t)

if t < 0.4
    % Left arm pushes ground
    inst(1, :) = [double(h.left_arm(1)), degtorad(90)];
    
    % Right arm close to body
    inst(2, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(3, :) = [double(h.right_arm(2)), degtorad(-90)];
    
    %Position right leg
    inst(4, :) = [double(h.right_leg(1)), degtorad(-60)];
    inst(5, :) = [double(h.right_leg(3)), degtorad(-10)];
    
    %Position left leg
    inst(6, :) = [double(h.left_leg(1)), degtorad(-60)];
    inst(7, :) = [double(h.left_leg(3)), degtorad(-10)];
elseif t < 1
    % left elbow prepares to push
    inst(1, :) = [double(h.left_arm(3)), degtorad(-90)];
    inst(2, :) = [double(h.left_arm(2)), degtorad(-80)];
    
    %Position right leg
    inst(3, :) = [double(h.right_leg(3)), degtorad(40)];
    
    %Position left leg
    inst(4, :) = [double(h.left_leg(3)), degtorad(-60)];
    
elseif t < 1.6
    % Push with left elbow
    %inst(1, :) = [double(h.left_arm(2)), degtorad(-90)];
    inst(1, :) = [double(h.left_arm(3)), degtorad(-30)];
    
    % Move right arm underneath body
    %inst(2, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(2, :) = [double(h.right_arm(2)), degtorad(-90)];
    
    % Position right leg
    inst(3, :) = [double(h.right_leg(1)), degtorad(0)];
    inst(4, :) = [double(h.right_leg(4)), degtorad(30)];
    
    % Position left leg
    inst(5, :) = [double(h.left_leg(1)), degtorad(0)];
else
    % Relax right leg
    inst(1, :) = [double(h.right_leg(1)), degtorad(0)];
    inst(2, :) = [double(h.right_leg(3)), degtorad(0)];
    inst(3, :) = [double(h.right_leg(4)), degtorad(0)];
    
    % Relax left leg
    inst(4, :) = [double(h.left_leg(1)), degtorad(0)];
    inst(5, :) = [double(h.left_leg(3)), degtorad(0)];
    inst(6, :) = [double(h.left_leg(4)), degtorad(0)];
    
    % Relax right arm
    inst(7, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(8, :) = [double(h.right_arm(2)), degtorad(80)];
    inst(9, :) = [double(h.right_arm(3)), degtorad(0)];
    
    % Relax left arm
    inst(10, :) = [double(h.left_arm(1)), degtorad(0)];
    inst(11, :) = [double(h.left_arm(2)), degtorad(-80)];
    inst(12, :) = [double(h.left_arm(3)), degtorad(0)];
end

end