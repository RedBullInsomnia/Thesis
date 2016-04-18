function handles = robot_init( vrep, clientID )
%ROBOT_INIT Summary of this function goes here
%   Detailed explanation goes here

handles = struct('clientID', clientID);

%% Retrieve center
[~, center] = vrep.simxGetObjectHandle(clientID, 'Central',...
    vrep.simx_opmode_oneshot_wait);
handles.center = center;

%% Retrieve servos' handles

% left_arm = [-1, -1];
% right_arm = [-1, -1];
% for i=1:2
%     [~, left_arm(i)] = vrep.simxGetObjectHandle(clientID,...
%         sprintf('left_arm_servo%d', i), vrep.simx_opmode_oneshot_wait);
%     [~, right_arm(i)] = vrep.simxGetObjectHandle(clientID,...
%         sprintf('right_arm_servo%d', i), vrep.simx_opmode_oneshot_wait);
% end
% 
% left_leg = [-1, -1, -1, -1];
% right_leg = [-1, -1, -1, -1];
% for i=1:4
%     [~, left_leg(i)] = vrep.simxGetObjectHandle(clientID,...
%         sprintf('left_leg_servo%d', (i+1)), vrep.simx_opmode_oneshot_wait);
%     [~, right_leg(i)] = vrep.simxGetObjectHandle(clientID,...
%         sprintf('right_leg_servo%d', (i+1)), vrep.simx_opmode_oneshot_wait);
% end
% 
% handles.left_arm = left_arm;
% handles.right_arm = right_arm;
% handles.left_leg = left_leg;
% handles.right_leg = right_leg;

%% Joints

j = 1;

left_arm_joints = [-1, -1, -1];
right_arm_joints = [-1, -1, -1];
for i = 1:3
    [~, left_arm_joints(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_arm%d', i), vrep.simx_opmode_oneshot_wait);
    [~, right_arm_joints(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_arm%d', i), vrep.simx_opmode_oneshot_wait);
    
    % Reset instructions
    instructions(j, :) = [double(left_arm_joints(i)), 0];
    j = j + 1;
    instructions(j, :) = [double(right_arm_joints(i)), 0];
    j = j + 1;
end

left_leg_joints = [-1, -1, -1, -1, -1, -1];
right_leg_joints = [-1, -1, -1, -1, -1, -1];
for i = 1:6
    [~, left_leg_joints(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_leg%d', i), vrep.simx_opmode_oneshot_wait);
    [~, right_leg_joints(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_leg%d', i), vrep.simx_opmode_oneshot_wait);
    
    instructions(j, :) = [double(left_leg_joints(i)), 0];
    j = j + 1;
    instructions(j, :) = [double(right_leg_joints(i)), 0];
    j = j + 1;
end

handles.left_leg_joints = left_leg_joints;
handles.right_leg_joints = right_leg_joints;
handles.left_arm_joints = left_arm_joints;
handles.right_arm_joints = right_arm_joints;

%% Retrieve cameras' handles

cameras = [-1, -1];
for i = 1:2
    [~, cameras(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('head%d', (i)), vrep.simx_opmode_oneshot_wait);
end

handles.cameras = cameras;

% Clear old instructions
send_instructions(vrep, clientID, instructions);

end
