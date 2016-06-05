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

left_arm = [-1, -1, -1];
right_arm = [-1, -1, -1];
for i = 1:3
    [~, left_arm(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_arm%d', i), vrep.simx_opmode_oneshot_wait);
    [~, right_arm(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_arm%d', i), vrep.simx_opmode_oneshot_wait);
    
    % Reset instructions
    instructions(j, :) = [double(left_arm(i)), 0]; j = j + 1;
    instructions(j, :) = [double(right_arm(i)), 0]; j = j + 1;
end

left_leg = [-1, -1, -1, -1, -1, -1];
right_leg = [-1, -1, -1, -1, -1, -1];
for i = 1:6
    [~, left_leg(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_leg%d', i), vrep.simx_opmode_oneshot_wait);
    [~, right_leg(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_leg%d', i), vrep.simx_opmode_oneshot_wait);
    
    instructions(j, :) = [double(left_leg(i)), 0]; j = j + 1;
    instructions(j, :) = [double(right_leg(i)), 0]; j = j + 1;
end

handles.left_leg = left_leg;
handles.right_leg = right_leg;
handles.left_arm = left_arm;
handles.right_arm = right_arm;

%% Retrieve cameras' handles

head = [-1, -1];
for i = 1:2
    [~, head(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('head%d', (i)), vrep.simx_opmode_oneshot_wait);
end

handles.head = head;

% Clear old instructions
send_instructions(vrep, clientID, instructions);

end
