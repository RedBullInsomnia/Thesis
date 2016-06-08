function instructions = standup_prone(h, t)

if t < 0.2
    
    % hips
    instructions(1,:) = [double(h.right_leg(3)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(30)];
    
    % feet
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-75)];
    instructions(4,:) = [double(h.left_leg(5)), degtorad(-75)];
    
    % right shoulder 
    instructions(5,:) = [double(h.right_arm(1)), degtorad(-100)];
    
    % left shoulder
    instructions(6,:) = [double(h.left_arm(1)), degtorad(-100)];
    
elseif t < 0.5
    
    % right shoulder 
    instructions(1,:) = [double(h.right_arm(2)), degtorad(70)];
    instructions(2,:) = [double(h.right_arm(3)), degtorad(70)];
    
    % left shoulder
    instructions(3,:) = [double(h.left_arm(2)), degtorad(-70)];
    instructions(4,:) = [double(h.left_arm(3)), degtorad(-70)];
    
elseif t < 0.9
    
    % right arm
    instructions(1,:) = [double(h.right_arm(2)), degtorad(80)];
    instructions(2,:) = [double(h.right_arm(3)), degtorad(40)];
    
    % left arm
    instructions(3,:) = [double(h.left_arm(2)), degtorad(-80)];
    instructions(4,:) = [double(h.left_arm(3)), degtorad(-40)];
    
    % Right leg
    instructions(5,:) = [double(h.right_leg(3)), degtorad(-40)];
    instructions(6,:) = [double(h.right_leg(5)), degtorad(-50)];
    
    % Left leg
    instructions(7,:) = [double(h.left_leg(3)), degtorad(-40)];
    instructions(8,:) = [double(h.left_leg(5)), degtorad(-50)];
    
elseif t < 1.4
    
    % Bring the knees in
    instructions(1,:) = [double(h.right_leg(4)), degtorad(80)];
    instructions(2,:) = [double(h.left_leg(4)), degtorad(80)];
    
    instructions(3,:) = [double(h.right_leg(3)), degtorad(-140)];
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-140)];
    
    % Use arms to lift trunk up
    % right arm
    instructions(5,:) = [double(h.right_arm(3)), degtorad(0)];
    
    % left arm
    instructions(6,:) = [double(h.left_arm(3)), degtorad(0)];
    
    % Feet
    instructions(7,:) = [double(h.right_leg(5)), degtorad(-30)];
    instructions(8,:) = [double(h.left_leg(5)), degtorad(-30)];
    
elseif t < 2
    
    % Feet
    instructions(1,:) = [double(h.right_leg(5)), degtorad(-14)];
    instructions(2,:) = [double(h.left_leg(5)), degtorad(-14)];
    
    % right arm
    instructions(3,:) = [double(h.right_arm(2)), degtorad(80)];
    
    % left arm 
    instructions(4,:) = [double(h.left_arm(2)), degtorad(-80)];

    % head
    instructions(5,:) = [double(h.head(1)), degtorad(-70)];
    
elseif t < 2.8
    
    % Time to stand
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-90)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(60)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-10)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-90)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(60)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
    % right arm
    instructions(7,:) = [double(h.right_arm(1)), degtorad(-15)];
    
    % left arm
    instructions(8,:) = [double(h.left_arm(1)), degtorad(-15)];
    
    % head
    instructions(9,:) = [double(h.head(1)), degtorad(0)];
    
elseif t < 3.2
    
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-70)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(50)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-10)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-70)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(50)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
else
    
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-50)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(40)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-8)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-50)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(40)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-8)];
    
end

end