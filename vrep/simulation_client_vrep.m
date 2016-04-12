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
h = robot_init(vrep, clientID);

% generate standup sequence
x = 0:.05:.1;
xq = 0:0.01:.1;
hips_setpoints = [degtorad(30), degtorad(-110), degtorad(-110)];
hips = interp1(x, hips_setpoints, xq, 'linear');

knees_setpoints = [0, degtorad(90), degtorad(110)];
knees = interp1(x, knees_setpoints, xq, 'linear');

feet_setpoints = [degtorad(-75), degtorad(-75), degtorad(-70)];
feet = interp1(x, feet_setpoints, xq, 'linear');

shoulders_setpoints = [degtorad(70), degtorad(70), degtorad(100)];
shoulders = interp1(x, shoulders_setpoints, xq, 'linear');

arms_setpoints = [degtorad(0), degtorad(0), degtorad(-90)];
arms = interp1(x, arms_setpoints, xq, 'linear');

elbows_setpoints = [degtorad(-90), degtorad(-90), degtorad(0)];
elbows = interp1(x, elbows_setpoints, xq, 'linear');

% display points
display = 0;
if display == 1
    figure
    subplot(5,1,1)
    plot(x, hips_setpoints, 'o', xq , hips, ':.');
    ylim([-2.5, 2.5])
    ylabel('hips')
    
    subplot(5,1,2)
    plot(x, knees_setpoints, 'o', xq , knees, ':.');
    ylim([-2.5, 2.5])
    ylabel('knees')
    
    subplot(5,1,3)
    plot(x, feet_setpoints, 'o', xq , feet, ':.');
    ylim([-2.5, 2.5])
    ylabel('feet')
    
    subplot(5,1,4)
    plot(x, shoulders_setpoints, 'o', xq , shoulders, ':.');
    ylim([-2.5, 2.5])
    ylabel('shoulders')
    
    subplot(5,1,5)
    plot(x, arms_setpoints, 'o', xq , arms, ':.');
    ylim([-2.5, 2.5])
    ylabel('arms')
end

t = 0;
i = 1;
while true && t < 0.5
    instructions = standup_prone(h, i, hips, knees, feet, shoulders, arms, elbows);
    COM(i,:) = getCOM(vrep, clientID);
    isInsideSupportArea(vrep, clientID, COM(i,:), h)
    send_instructions(vrep, clientID, instructions);
    t = t + dt
    if i < 11
        i = i + 1;
    end
end

if display == 1
    figure
    plot3(COM(:,1), COM(:,2), COM(:,3))
end

% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
vrep.simxGetPingTime(clientID);

% Now close the connection to V-REP:
%vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(clientID);
vrep.delete(); % call the destructor!
disp('Program ended');
end