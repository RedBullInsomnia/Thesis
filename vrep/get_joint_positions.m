function positions = get_joint_positions(vrep, id, h)
% 3 joints in each arm left, right
% 6 joints in each leg left, right

j = 1;
positions = zeros(18,1);
for i = 1:3
    [~, positions(j)] = vrep.simxGetJointPosition(id,...
        h.left_arm(i), vrep.simx_opmode_oneshot_wait); j = j + 1;
end

for i = 1:3
    [~, positions(j)] = vrep.simxGetJointPosition(id,...
        h.right_arm(i), vrep.simx_opmode_oneshot_wait); j = j + 1;
end

for i = 1:6
    [~, positions(j)] = vrep.simxGetJointPosition(id,...
        h.left_leg(i), vrep.simx_opmode_oneshot_wait); j = j + 1;
end

for i=1:6
    [~, positions(j)] = vrep.simxGetJointPosition(id,...
        h.right_leg(i), vrep.simx_opmode_oneshot_wait); j = j + 1;
end 

end