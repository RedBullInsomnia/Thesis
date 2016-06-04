function instructions = standup_prone(h, t)

if t < 0.7
    % Phase 1 Lift the trunk;
    %hips
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(30)];
    
    % feet
    instructions(3,:) = [double(h.right_leg_joints(5)), degtorad(-75)];
    instructions(4,:) = [double(h.left_leg_joints(5)), degtorad(-75)];
    
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-90)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-90)];
    
    instructions(7,:) = [double(h.right_arm_joints(2)), degtorad(90)];
    instructions(8,:) = [double(h.left_arm_joints(2)), degtorad(-90)];
    
    
elseif t < 1.4
    % Phase 2 Faire le dos rond
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(-40)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(-40)];
    
    instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-100)];
    instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-100)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg_joints(5)), degtorad(-40)];
    instructions(6,:) = [double(h.left_leg_joints(5)), degtorad(-40)];
elseif t < 2.5
    % Phase 3 Bring the knees in
    instructions(1,:) = [double(h.right_leg_joints(4)), degtorad(80)];
    instructions(2,:) = [double(h.left_leg_joints(4)), degtorad(80)];
    
    instructions(3,:) = [double(h.right_leg_joints(3)), degtorad(-140)];
    instructions(4,:) = [double(h.left_leg_joints(3)), degtorad(-140)];
    
    % Use arms to lift trunk up
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-75)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-75)];
    
    % Feet
    instructions(7,:) = [double(h.right_leg_joints(5)), degtorad(-14)];
    instructions(8,:) = [double(h.left_leg_joints(5)), degtorad(-14)];
else
    % Phase 4 Stand up
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(-100)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(-100)];
    
    instructions(3,:) = [double(h.right_leg_joints(4)), degtorad(40)];
    instructions(4,:) = [double(h.left_leg_joints(4)), degtorad(40)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg_joints(5)), degtorad(-20)];
    instructions(6,:) = [double(h.left_leg_joints(5)), degtorad(-20)];
    %
    %     % Arms
    %     instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-30)];
    %     instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-30)];
    %
    % Knees
    %      instructions(5,:) = [double(h.right_leg_joints(4)), degtorad(60)];
    %      instructions(6,:) = [double(h.left_leg_joints(4)), degtorad(60)];
    % %
    %      % Feet
    %      instructions(7,:) = [double(h.right_leg_joints(5)), degtorad(-20)];
    %      instructions(8,:) = [double(h.left_leg_joints(5)), degtorad(-20)];
end

end