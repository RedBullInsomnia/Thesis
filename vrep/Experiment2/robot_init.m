function handles = robot_init( vrep, clientID )
%ROBOT_INIT Summary of this function goes here
%   Detailed explanation goes here

handles = struct('clientID', clientID);
[~, joint] = vrep.simxGetObjectHandle(clientID, 'joint', ...
    vrep.simx_opmode_oneshot_wait);

handles.joint = joint;

end
