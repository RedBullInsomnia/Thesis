function simulation_client_vrep()

dt = .01;

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

% Retrieve center of mass
%[~, centerZ] = vrep.simxGetFloatSignal(clientID, 'centerOfMassZ', vrep.simx_opmode_oneshot_wait);

% generate standup sequence
x = 0:.1:.3;
xq = 0:0.01:.3;
hips_setpoints = [degtorad(30), degtorad(-40), degtorad(-150), degtorad(-20)];
hips = interp1(x, hips_setpoints, xq, 'spline');

knees_setpoints = [0, 0, degtorad(120), degtorad(20)];
knees = interp1(x, knees_setpoints, xq, 'spline');

feet_setpoints = [degtorad(-65), degtorad(-55), degtorad(-30), degtorad(0)];
feet = interp1(x, feet_setpoints, xq, 'spline');

shoulders_setpoints = [degtorad(-70), degtorad(-100), degtorad(-75), degtorad(-30)];
shoulders = interp1(x, shoulders_setpoints, xq, 'spline');

arms_setpoints = [degtorad(-90), degtorad(-90), degtorad(-90), degtorad(-90)];
arms = interp1(x, arms_setpoints, xq, 'linear');

% display points
figure
subplot(5,1,1)
plot(x, hips_setpoints, 'o', xq , hips, ':.');

subplot(5,1,2)
plot(x, knees_setpoints, 'o', xq , knees, ':.');

subplot(5,1,3)
plot(x, feet_setpoints, 'o', xq , feet, ':.');

subplot(5,1,4)
plot(x, shoulders_setpoints, 'o', xq , shoulders, ':.');

t = 0;
i = 1;
while true && t < 1
    instructions = standup_prone(handles, i, hips, knees, feet, shoulders, arms);
    send_instructions(vrep, clientID, instructions);
    t = t + dt
    if i < 31
        i = i + 1;
    end
end

% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
vrep.simxGetPingTime(clientID);

% Now close the connection to V-REP:
vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(clientID);
vrep.delete(); % call the destructor!
disp('Program ended');
end