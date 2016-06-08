function simulation_client_vrep()

disp('Program started');
vrep = remApi('remoteApi'); % use the prototype file
vrep.simxFinish(-1); % close all opened connections
clientID = vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);

if clientID < 0
    disp('Failed connecting. Exiting.');
    vrep.delete();
    return;
end
disp('Connected to remote API server');

% Close the connexion whenever the script is interrupted.
cleanupObj = onCleanup(@() cleanup_vrep(vrep, clientID));

% Set the remote mode to 'synchronous'
vrep.simxSynchronous(clientID, true);

% retrieve handles to servos, joints
h = robot_init(vrep, clientID);

% start the simulation
vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot_wait);

t = 0;
dt = 0.1; %timestep of the simulation
while true && t < 3
    instructions = standup_prone(h, t);
    send_instructions(vrep, clientID, instructions);
    t = t + dt;
end

% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive.
vrep.simxGetPingTime(clientID);

% Close the connection to V-REP:
vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(clientID);
vrep.delete(); % call the destructor!
disp('Program ended');
end
