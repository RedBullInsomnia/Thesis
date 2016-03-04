function simulation_client_vrep()
    timestep = .01;
    
	disp('Program started');
	vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID = vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);

	if clientID < 0
        disp('Failed connecting to remote API server. Exiting.');
        vrep.delete();
        return;
    end
    disp('Connected to remote API server');
    
    % Make sure we close the connexion whenever the script is interrupted.
    cleanupObj = onCleanup(@() cleanup_vrep(vrep, clientID));
    
    % This will only work in "continuous remote API server service"
    % See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
    vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot_wait);
    
    % retrieve handles to servos, joints
    handles = robot_init(vrep, clientID);
    
    [~, centerZ] = vrep.simxGetFloatSignal(clientID, 'centerOfMassZ', vrep.simx_opmode_oneshot_wait)
    
    instructions(1,:) = [double(handles.joints(2)), 20*pi/180];
    instructions(2,:) = [double(handles.joints(16)), -10*pi/180];
    
    for i=0:100
        send_instructions(vrep, clientID, instructions);
    end
    
    % Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
    vrep.simxGetPingTime(clientID);

    % Now close the connection to V-REP:	
    vrep.simxFinish(clientID);
	vrep.delete(); % call the destructor!
	disp('Program ended');
end