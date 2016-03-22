function instructions = standup_prone(h, i, hips, knees, feet, shoulders, arms)

instructions(1,:) = [double(h.right_leg_joints(2)), hips(i)];
instructions(2,:) = [double(h.left_leg_joints(2)), hips(i)];

instructions(3,:) = [double(h.right_leg_joints(4)), knees(i)];
instructions(4,:) = [double(h.left_leg_joints(4)), knees(i)];

instructions(5,:) = [double(h.right_leg_joints(6)), feet(i)];
instructions(6,:) = [double(h.left_leg_joints(6)), feet(i)];

instructions(7,:) = [double(h.right_arm_joints(1)), shoulders(i)];
instructions(8,:) = [double(h.left_arm_joints(1)), shoulders(i)];

instructions(9,:) = [double(h.right_arm_joints(2)), arms(i)];
instructions(10,:) = [double(h.left_arm_joints(2)), -arms(i)];

end