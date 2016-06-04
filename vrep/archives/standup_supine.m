function instructions = standup_supine(h, t)

if t < 0.3
    % Phase 1 Lift the trunk;
    instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-120)];
    instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(-120)];
    
    % feet
    instructions(3,:) = [double(h.right_leg_joints(6)), degtorad(25)];
    instructions(4,:) = [double(h.left_leg_joints(6)), degtorad(25)];
      
    % knees
    instructions(5,:) = [double(h.right_leg_joints(4)), degtorad(90)];
    instructions(6,:) = [double(h.left_leg_joints(4)), degtorad(90)];
    
    % arms
    instructions(7,:) = [double(h.right_arm_joints(1)), degtorad(40)];
    instructions(8,:) = [double(h.left_arm_joints(1)), degtorad(40)];
    instructions(9,:) = [double(h.right_arm_joints(2)), degtorad(-90)];
    instructions(10,:) = [double(h.left_arm_joints(2)), degtorad(90)];
    
elseif t < 0.4
    % Phase 2 
    % arms
    instructions(1,:) = [double(h.right_arm_joints(1)), degtorad(90)];
    instructions(2,:) = [double(h.left_arm_joints(1)), degtorad(90)];
    
    % hips
    instructions(3,:) = [double(h.right_leg_joints(2)), degtorad(0)];
    instructions(4,:) = [double(h.left_leg_joints(2)), degtorad(0)];
    
    % knees
    instructions(5,:) = [double(h.right_leg_joints(4)), degtorad(80)];
    instructions(6,:) = [double(h.left_leg_joints(4)), degtorad(80)];
    
    % feet
    instructions(7,:) = [double(h.right_leg_joints(6)), degtorad(-45)];
    instructions(8,:) = [double(h.left_leg_joints(6)), degtorad(-45)];
else%if t < 0.5
    % arms
    instructions(1,:) = [double(h.right_arm_joints(1)), degtorad(70)];
    instructions(2,:) = [double(h.left_arm_joints(1)), degtorad(70)];
    
    % hips
    instructions(3,:) = [double(h.right_leg_joints(2)), degtorad(25)];
    instructions(4,:) = [double(h.left_leg_joints(2)), degtorad(25)];
    
    % knees
    instructions(5,:) = [double(h.right_leg_joints(4)), degtorad(120)];
    instructions(6,:) = [double(h.left_leg_joints(4)), degtorad(120)];
    
    % feet
    instructions(7,:) = [double(h.right_leg_joints(6)), degtorad(-80)];
    instructions(8,:) = [double(h.left_leg_joints(6)), degtorad(-80)];
% else
%     % arms
%     instructions(1,:) = [double(h.right_arm_joints(1)), degtorad(-40)];
%     instructions(2,:) = [double(h.left_arm_joints(1)), degtorad(-40)];
%     instructions(3,:) = [double(h.right_arm_joints(2)), degtorad(-60)];
%     instructions(4,:) = [double(h.left_arm_joints(2)), degtorad(60)];
%     
%     % hips
%     instructions(5,:) = [double(h.right_leg_joints(2)), degtorad(-10)];
%     instructions(6,:) = [double(h.left_leg_joints(2)), degtorad(-10)];
%     
%     % knees
%     instructions(7,:) = [double(h.right_leg_joints(4)), degtorad(50)];
%     instructions(8,:) = [double(h.left_leg_joints(4)), degtorad(50)];
%     
%     % feet
%     instructions(9,:) = [double(h.right_leg_joints(6)), degtorad(-10)];
%     instructions(10,:) = [double(h.left_leg_joints(6)), degtorad(-10)];

end

end