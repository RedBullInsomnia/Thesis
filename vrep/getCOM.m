function COM = getCOM( vrep, clientID )
%GETCOM Summary of this function goes here
%   Detailed explanation goes here

[~, COM(1)] = vrep.simxGetFloatSignal(clientID, 'centerOfMassX', vrep.simx_opmode_oneshot_wait);
[~, COM(2)] = vrep.simxGetFloatSignal(clientID, 'centerOfMassY', vrep.simx_opmode_oneshot_wait);
[~, COM(3)] = vrep.simxGetFloatSignal(clientID, 'centerOfMassZ', vrep.simx_opmode_oneshot_wait);

end

