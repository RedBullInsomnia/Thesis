function instructions = standup_supine(h, t)

if t < 0.3
    % Phase 1 Lift the trunk;
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-120)];
    instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(-120)];
    
    instructions(3,:) = [double(h.right_leg_joints(6)), degtorad(45)];
    instructions(4,:) = [double(h.left_leg_joints(6)), degtorad(45)];
    
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(70)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(70)];
    
    instructions(7,:) = [double(h.right_arm_joints(2)), degtorad(-90)];
    instructions(8,:) = [double(h.left_arm_joints(2)), degtorad(90)];
    
    instructions(9,:) = [double(h.right_leg_joints(4)), degtorad(90)];
    instructions(10,:) = [double(h.left_leg_joints(4)), degtorad(90)];
else
    % Phase 2 
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-40)];

end

end