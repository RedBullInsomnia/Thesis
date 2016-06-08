function simulation_client_vrep()
dt = .01;

disp('Program started');
vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
id = vrep.simxStart('127.0.0.1', 19997, true, true, 5000, 5);

if id < 0
    disp('Failed connecting to remote API server. Exiting.');
    vrep.delete();
    return;
end
disp('Connected to remote API server');

% Make sure we close the connexion whenever the script is interrupted.
cleanupObj = onCleanup(@() cleanup_vrep(vrep, id));

% This will only work in "continuous remote API server service"
% See http://www.v-rep.eu/helpFiles/en/remoteApiServerSide.htm
vrep.simxSynchronous(id, true);

% retrieve handles to servos, joints
h = robot_init(vrep, id);
reset_robot_position(vrep, id, h, 'prone');

vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);

% display points
t = 0;
i = 1;
while t < 4
    instructions = standup_prone(h, t);
    
    send_instructions(vrep, id, instructions);
    i = i + 1; t = t + dt
end

% Before closing the connection to V-REP, make sure that the last command 
% sent out had time to arrive.
vrep.simxGetPingTime(id);

%t = 0:dt:4;
%positions = rad2deg(positions);
%plot_results(t, positions);

% Now close the connection to V-REP:
vrep.simxStopSimulation(id, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(id);
vrep.delete(); % call the destructor!
disp('Program ended');
end

function instructions = walk(h, t)

if t < 0.2
    instructions(1, : ) = [double(h.right_leg(2)), degtorad(0)];
elseif t < 0.3
    % bring body over the right leg
    instructions(1, :) = [double(h.right_leg(2)), degtorad(12)];
    instructions(2, :) = [double(h.right_leg(6)), degtorad(-12)];
    
    % bring arm close to body
    instructions(3, :) = [double(h.left_arm(2)), degtorad(-70)];
    
elseif t < 0.5
    
    instructions(1, :) = [double(h.right_leg(2)), degtorad(12)];
    instructions(2, :) = [double(h.right_leg(6)), degtorad(-14)];
    instructions(3, :) = [double(h.left_leg(3)), degtorad(-30)];
    instructions(4, :) = [double(h.left_leg(4)), degtorad(30)];
    instructions(5, :) = [double(h.left_leg(5)), degtorad(-30)];

% elseif t < 0.7
% 
%     instructions(1, :) = [double(h.right_leg(3)), degtorad(-16)];
%     instructions(2, :) = [double(h.right_leg(6)), degtorad(0)];
%     
% else
%     
%     instructions(1, :) = [double(h.left_leg(3)), degtorad(0)];
%     instructions(2, :) = [double(h.left_leg(4)), degtorad(0)];
%     instructions(3, :) = [double(h.left_leg(5)), degtorad(0)];
%     instructions(4, : ) = [double(h.right_leg(2)), degtorad(0)];
%     
% end
% 

else
    instructions(1, :) = [double(h.left_arm(2)), degtorad(-70)];
end

end