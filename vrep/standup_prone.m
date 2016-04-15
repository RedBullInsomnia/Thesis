function instructions = standup_prone(h, i, hips, knees, feet, shoulders, arms, elbows)

if i > length(hips)
    instructions(1, :) = [double(h.right_leg_joints(2)), hips(end)];
    return;
end

instructions(1,:) = [double(h.right_leg_joints(3)), hips(i)];
instructions(2,:) = [double(h.left_leg_joints(3)), hips(i)];

instructions(3,:) = [double(h.right_leg_joints(4)), knees(i)];
instructions(4,:) = [double(h.left_leg_joints(4)), knees(i)];

instructions(5,:) = [double(h.right_leg_joints(5)), feet(i)];
instructions(6,:) = [double(h.left_leg_joints(5)), feet(i)];

instructions(7,:) = [double(h.right_arm_joints(1)), shoulders(i)];
instructions(8,:) = [double(h.left_arm_joints(1)), shoulders(i)];

instructions(9,:) = [double(h.right_arm_joints(2)), arms(i)];
instructions(10,:) = [double(h.left_arm_joints(2)), -arms(i)];

instructions(11,:) = [double(h.right_arm_joints(3)), elbows(i)];
instructions(12,:) = [double(h.left_arm_joints(3)), -elbows(i)];

end

% function instructions = standup_prone(h, t)
% 
% if t < 0.2
%     % Phase 1 Lift the trunk;
%     instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(30)];
%     instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(30)];
%     
%     instructions(3,:) = [double(h.right_leg_joints(6)), degtorad(-65)];
%     instructions(4,:) = [double(h.left_leg_joints(6)), degtorad(-65)];
%     
%     instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-70)];
%     instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-70)];
%     
%     instructions(7,:) = [double(h.right_arm_joints(2)), degtorad(-90)];
%     instructions(8,:) = [double(h.left_arm_joints(2)), degtorad(90)];
% elseif t < 0.3
%     % Phase 2 Faire le dos rond
%     instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-40)];
%     instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(-40)];
%     
%     instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-100)];
%     instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-100)];
%     
%     % Feet
%     instructions(5,:) = [double(h.right_leg_joints(6)), degtorad(-75)];
%     instructions(6,:) = [double(h.left_leg_joints(6)), degtorad(-75)];
% elseif t < 0.4
%     % Phase 3 Bring the knees in
%     instructions(1,:) = [double(h.right_leg_joints(4)), degtorad(120)];
%     instructions(2,:) = [double(h.left_leg_joints(4)), degtorad(120)];
%     
%     instructions(3,:) = [double(h.right_leg_joints(2)), degtorad(-150)];
%     instructions(4,:) = [double(h.left_leg_joints(2)), degtorad(-150)];
%     
%     % Use arms to lift trunk up
%     instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-75)];
%     instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-75)];
%     
%     % Feet
%     instructions(7,:) = [double(h.right_leg_joints(6)), degtorad(-22)];
%     instructions(8,:) = [double(h.left_leg_joints(6)), degtorad(-22)];
%  else
%     % Phase 4 Stand up
%     instructions(1,:) = [double(h.right_leg_joints(2)), degtorad(-40)];
%     instructions(2,:) = [double(h.left_leg_joints(2)), degtorad(-40)];
%     
%     % Arms
%     instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-30)];
%     instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-30)];
%     
%     instructions(5,:) = [double(h.right_leg_joints(4)), degtorad(60)];
%     instructions(6,:) = [double(h.left_leg_joints(4)), degtorad(60)];
%     
% end
% 
% end