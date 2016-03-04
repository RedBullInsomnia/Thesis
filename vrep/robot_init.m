function handles = robot_init( vrep, clientID )
%ROBOT_INIT Summary of this function goes here
%   Detailed explanation goes here

handles = struct('clientID', clientID);

% Retrieve servos' handles
left_arm = [-1, -1, -1];
right_arm = [-1, -1, -1];
for i=1:3
    [~, left_arm(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_arm%d', (i-1)), vrep.simx_opmode_oneshot_wait);
    [~, right_arm(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_arm%d', (i-1)), vrep.simx_opmode_oneshot_wait);
end

left_leg = [-1, -1, -1, -1, -1, -1];
right_leg = [-1, -1, -1, -1, -1, -1];
for i=1:6
    [~, left_leg(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('left_leg%d', (i-1)), vrep.simx_opmode_oneshot_wait);
    [~, right_leg(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('right_leg%d', (i-1)), vrep.simx_opmode_oneshot_wait);
end

handles.left_arm = left_arm;
handles.right_arm = right_arm;
handles.left_leg = left_leg;
handles.right_leg = right_leg;

% Retrieve cameras' handles
cameras = [-1, -1];
for i=1:2
    [~, left_leg(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('camera%d', (i-1)), vrep.simx_opmode_oneshot_wait);
end

handles.cameras = cameras;

% Retrieve joints' handles
joints = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
for i=1:16
    [~, joints(i)] = vrep.simxGetObjectHandle(clientID,...
        sprintf('joint%d', (i-1)), vrep.simx_opmode_oneshot_wait);
end

handles.joints = joints;

end

