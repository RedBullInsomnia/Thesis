% This small example illustrates how to use the remote API
% synchronous mode. The synchronous mode needs to be
% pre-enabled on the server side. You would do this by
% starting the server (e.g. in a child script) with:
%
% simExtRemoteApiStart(19999,1300,false,true)
%
% But in this example we try to connect on port
% 19997 where there should be a continuous remote API
% server service already running and pre-enabled for
% synchronous mode.
%
% IMPORTANT: for each successful call to simxStart, there
% should be a corresponding call to simxFinish at the end!

function simulation_client_vrep()
	disp('Program started');
	vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
	vrep.simxFinish(-1); % just in case, close all opened connections
	clientID = vrep.simxStart('127.0.0.1',19997,true,true,5000,5);
    
	if (clientID>-1)
		disp('Connected to remote API server');
        
        % make sure we close the connection if we interrupt the program
        cleanupObj = onCleanup(@() cleanup_vrep(vrep, clientID));

		% enable the synchronous mode on the client:
		vrep.simxSynchronous(clientID, true);
        
        % retrieve handles to joints
        handles = struct('clientID', clientID);
        for i=0:15
            [~, handles.joint(i+1)] = vrep.simxGetObjectHandle(clientID, sprintf('Robot_joint%d',i), vrep.simx_opmode_blocking);
        end
        
		% start the simulation:
		vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot_wait);

		% Now step a few times:
		for i=0:500
            vrep.simxSetJointTargetPosition(clientID, handles.joint(2), 20*pi/180, vrep.simx_opmode_oneshot);
            vrep.simxSetJointTargetPosition(clientID, handles.joint(16), -15*pi/180, vrep.simx_opmode_oneshot);
            
            vrep.simxSynchronousTrigger(clientID);
            vrep.simxGetPingTime(clientID);
		end

		% stop the simulation, and close the connection to vrep
		vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
		vrep.simxFinish(clientID);
	else
		disp('Failed connecting to remote API server');
	end
	vrep.delete(); % call the destructor!
	
	disp('Program ended');
end
