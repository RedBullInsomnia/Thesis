function instructions = standup_prone(h, t)

if t < 0.3
    % Phase 1 Lift the trunk;
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(30)];
    
    instructions(3,:) = [double(h.right_leg_joints(6)), degtorad(-25)];
    instructions(4,:) = [double(h.left_leg_joints(6)), degtorad(-25)];
    
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-70)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-70)];
    
    instructions(7,:) = [double(h.right_arm_joints(2)), degtorad(-90)];
    instructions(8,:) = [double(h.left_arm_joints(2)), degtorad(90)];
elseif t < 0.5
    % Phase 2 Faire le dos rond
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-40)];
    instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(-40)];
    
    instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-100)];
    instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-100)];
elseif t < 0.6
    % Phase 3 Bring the knees in
    instructions(1,:) = [double(h.right_leg_joints(4)), degtorad(90)];
    instructions(2,:) = [double(h.left_leg_joints(4)), degtorad(90)];
    
    instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-120)];
    instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-120)];
    
    instructions(5,:) = [double(h.right_leg_joints(2)), degtorad(-140)];
    instructions(6,:) = [double(h.left_leg_joints(2)), degtorad(-140)];
else
    % Phase 4
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(0)];
    instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(0)];
end

end