function res = send_instructions( vrep, clientID, angle_instructions )
%SEND_INSTRUCTION Summary of this function goes here
%   Detailed explanation goes here
    
    vrep.simxPauseCommunication(clientID, 1);
    for i=1:size(angle_instructions, 1)
       res = vrep.simxSetJointTargetPosition(clientID, ...
           angle_instructions(i, 1), angle_instructions(i, 2), ...
           vrep.simx_opmode_oneshot);
    end
    vrep.simxPauseCommunication(clientID, 0);
    
    vrep.simxGetPingTime(clientID);
    vrep.simxSynchronousTrigger(clientID);
end

