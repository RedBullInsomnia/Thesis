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
vrep.simxSynchronous(clientID, true);

% retrieve handles to servos, joints
h = robot_init(vrep, clientID);

vrep.simxStartSimulation(clientID, vrep.simx_opmode_oneshot_wait);

% display points
t = 0;

i = 1;
while true && t < 3
    instructions = standup_prone(h, t);
    %instructions = walk(h, t);
    
    i = i + 1;
    %COM(i,:) = getCOM(vrep, clientID);
    %isInsideSupportArea(vrep, clientID, COM(i,:), h)
    send_instructions(vrep, clientID, instructions);
    t = t + dt
end

% Before closing the connection to V-REP, make sure that the last command sent out had time to arrive. You can guarantee this with (for example):
vrep.simxGetPingTime(clientID);

% Now close the connection to V-REP:
%vrep.simxStopSimulation(clientID, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(clientID);
vrep.delete(); % call the destructor!
disp('Program ended');
end

function instructions = standup_prone(h, t)

if t < 0.4
    % Phase 1 Lift the trunk;
    %hips
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(30)];
    
    % feet
    instructions(3,:) = [double(h.right_leg_joints(5)), degtorad(-75)];
    instructions(4,:) = [double(h.left_leg_joints(5)), degtorad(-75)];
    
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-90)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-90)];
    
    instructions(7,:) = [double(h.right_arm_joints(2)), degtorad(90)];
    instructions(8,:) = [double(h.left_arm_joints(2)), degtorad(-90)];
    
    
elseif t < 0.8
    % Phase 2 Faire le dos rond
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(-40)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(-40)];
    
    instructions(3,:) = [double(h.right_arm_joints(1)), degtorad(-100)];
    instructions(4,:) = [double(h.left_arm_joints(1)), degtorad(-100)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg_joints(5)), degtorad(-40)];
    instructions(6,:) = [double(h.left_leg_joints(5)), degtorad(-40)];
elseif t < 1.8
    % Phase 3 Bring the knees in
    instructions(1,:) = [double(h.right_leg_joints(4)), degtorad(80)];
    instructions(2,:) = [double(h.left_leg_joints(4)), degtorad(80)];
    
    instructions(3,:) = [double(h.right_leg_joints(3)), degtorad(-140)];
    instructions(4,:) = [double(h.left_leg_joints(3)), degtorad(-140)];
    
    % Use arms to lift trunk up
    instructions(5,:) = [double(h.right_arm_joints(1)), degtorad(-75)];
    instructions(6,:) = [double(h.left_arm_joints(1)), degtorad(-75)];
    
    % Feet
    instructions(7,:) = [double(h.right_leg_joints(5)), degtorad(-14)];
    instructions(8,:) = [double(h.left_leg_joints(5)), degtorad(-14)];
    
elseif t < 2.4
    % Phase 4 Stand up
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(-80)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(-80)];
    
    instructions(3,:) = [double(h.right_leg_joints(4)), degtorad(60)];
    instructions(4,:) = [double(h.left_leg_joints(4)), degtorad(60)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg_joints(5)), degtorad(-10)];
    instructions(6,:) = [double(h.left_leg_joints(5)), degtorad(-10)];
    
    % Arms
    instructions(7,:) = [double(h.right_arm_joints(1)), degtorad(-30)];
    instructions(8,:) = [double(h.left_arm_joints(1)), degtorad(-30)];
else
    instructions(1,:) = [double(h.right_leg_joints(3)), degtorad(-20)];
    instructions(2,:) = [double(h.left_leg_joints(3)), degtorad(-20)];
    
    instructions(3,:) = [double(h.right_leg_joints(4)), degtorad(20)];
    instructions(4,:) = [double(h.left_leg_joints(4)), degtorad(20)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg_joints(5)), degtorad(-10)];
    instructions(6,:) = [double(h.left_leg_joints(5)), degtorad(-10)];
    
    % Arms
    instructions(7,:) = [double(h.right_arm_joints(1)), degtorad(-30)];
    instructions(8,:) = [double(h.left_arm_joints(1)), degtorad(-30)];
end
end

function instructions = walk(h, t)

if t < 0.2
    instructions(1, : ) = [double(h.right_leg_joints(2)), degtorad(0)];
elseif t < 0.3
    % bring body over the right leg
    instructions(1, :) = [double(h.right_leg_joints(2)), degtorad(12)];
    instructions(2, :) = [double(h.right_leg_joints(6)), degtorad(-12)];
    
    % bring arm close to body
    instructions(3, :) = [double(h.left_arm_joints(2)), degtorad(-70)];
    
elseif t < 0.5
    
    instructions(1, :) = [double(h.right_leg_joints(2)), degtorad(12)];
    instructions(2, :) = [double(h.right_leg_joints(6)), degtorad(-14)];
    instructions(3, :) = [double(h.left_leg_joints(3)), degtorad(-30)];
    instructions(4, :) = [double(h.left_leg_joints(4)), degtorad(30)];
    instructions(5, :) = [double(h.left_leg_joints(5)), degtorad(-30)];

% elseif t < 0.7
% 
%     instructions(1, :) = [double(h.right_leg_joints(3)), degtorad(-16)];
%     instructions(2, :) = [double(h.right_leg_joints(6)), degtorad(0)];
%     
% else
%     
%     instructions(1, :) = [double(h.left_leg_joints(3)), degtorad(0)];
%     instructions(2, :) = [double(h.left_leg_joints(4)), degtorad(0)];
%     instructions(3, :) = [double(h.left_leg_joints(5)), degtorad(0)];
%     instructions(4, : ) = [double(h.right_leg_joints(2)), degtorad(0)];
%     
% end
% 

else
    instructions(1, :) = [double(h.left_arm_joints(2)), degtorad(-70)];
end

end