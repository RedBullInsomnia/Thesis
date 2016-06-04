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
reset_robot_position(vrep, id, h, 'supine');

vrep.simxStartSimulation(id, vrep.simx_opmode_oneshot_wait);

% display points
t = 0;
i = 1;
while true && t < 3
    %instructions = standup_prone(h, t);
    instructions = go_prone(h, t);
    positions(:, i) = get_joint_positions(vrep, id, h);
    
    %COM(i,:) = getCOM(vrep, clientID);
    %isInsideSupportArea(vrep, clientID, COM(i,:), h)
    send_instructions(vrep, id, instructions);
    i = i + 1; t = t + dt
end

% Before closing the connection to V-REP, make sure that the last command 
% sent out had time to arrive.
vrep.simxGetPingTime(id);

t = 0:dt:3;
positions = rad2deg(positions);
plot_results(t, positions);

% Now close the connection to V-REP:
vrep.simxStopSimulation(id, vrep.simx_opmode_oneshot_wait);
vrep.simxFinish(id);
vrep.delete(); % call the destructor!
disp('Program ended');
end

function inst = go_prone(h, t)

if t < 0.4
    % Left arm pushes ground
    inst(1, :) = [double(h.left_arm(1)), degtorad(90)];
    
    % Right arm close to body
    inst(2, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(3, :) = [double(h.right_arm(2)), degtorad(-90)];
    
    %Position right leg
    inst(4, :) = [double(h.right_leg(1)), degtorad(-60)];
    inst(5, :) = [double(h.right_leg(3)), degtorad(-10)];
    
    %Position left leg
    inst(6, :) = [double(h.left_leg(1)), degtorad(-60)];
    inst(7, :) = [double(h.left_leg(3)), degtorad(-10)];
elseif t < 1
    % left elbow prepares to push
    inst(1, :) = [double(h.left_arm(3)), degtorad(-90)];
    inst(2, :) = [double(h.left_arm(2)), degtorad(-80)];
    
    %Position right leg
    inst(3, :) = [double(h.right_leg(3)), degtorad(40)];
    
    %Position left leg
    inst(4, :) = [double(h.left_leg(3)), degtorad(-60)];
    
elseif t < 1.6
    % Push with left elbow
    %inst(1, :) = [double(h.left_arm(2)), degtorad(-90)];
    inst(1, :) = [double(h.left_arm(3)), degtorad(-30)];
    
    % Move right arm underneath body
    %inst(2, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(2, :) = [double(h.right_arm(2)), degtorad(-90)];
    
    % Position right leg
    inst(3, :) = [double(h.right_leg(1)), degtorad(0)];
    inst(4, :) = [double(h.right_leg(4)), degtorad(30)];
    
    % Position left leg
    inst(5, :) = [double(h.left_leg(1)), degtorad(0)];
else
    % Relax right leg
    inst(1, :) = [double(h.right_leg(1)), degtorad(0)];
    inst(2, :) = [double(h.right_leg(3)), degtorad(0)];
    inst(3, :) = [double(h.right_leg(4)), degtorad(0)];
    
    % Relax left leg
    inst(4, :) = [double(h.left_leg(1)), degtorad(0)];
    inst(5, :) = [double(h.left_leg(3)), degtorad(0)];
    inst(6, :) = [double(h.left_leg(4)), degtorad(0)];
    
    % Relax right arm
    inst(7, :) = [double(h.right_arm(1)), degtorad(0)];
    inst(8, :) = [double(h.right_arm(2)), degtorad(80)];
    inst(9, :) = [double(h.right_arm(3)), degtorad(0)];
    
    % Relax left arm
    inst(10, :) = [double(h.left_arm(1)), degtorad(0)];
    inst(11, :) = [double(h.left_arm(2)), degtorad(-80)];
    inst(12, :) = [double(h.left_arm(3)), degtorad(0)];
end

end

function instructions = standup_prone(h, t)

if t < 0.4
    % Phase 1 Lift the trunk;
    %hips
    instructions(1,:) = [double(h.right_leg(3)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(30)];
    
    % feet
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-75)];
    instructions(4,:) = [double(h.left_leg(5)), degtorad(-75)];
    
    instructions(5,:) = [double(h.right_arm(1)), degtorad(-90)];
    instructions(6,:) = [double(h.left_arm(1)), degtorad(-90)];
    
    instructions(7,:) = [double(h.right_arm(2)), degtorad(90)];
    instructions(8,:) = [double(h.left_arm(2)), degtorad(-90)];
    
elseif t < 0.8
    % Phase 2 Faire le dos rond
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-40)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(-40)];
    
    instructions(3,:) = [double(h.right_arm(1)), degtorad(-90)];
    instructions(4,:) = [double(h.left_arm(1)), degtorad(-90)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg(5)), degtorad(-60)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-60)];
elseif t < 1.8
    % Phase 3 Bring the knees in
    instructions(1,:) = [double(h.right_leg(4)), degtorad(80)];
    instructions(2,:) = [double(h.left_leg(4)), degtorad(80)];
    
    instructions(3,:) = [double(h.right_leg(3)), degtorad(-140)];
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-140)];
    
    % Use arms to lift trunk up
    instructions(5,:) = [double(h.right_arm(1)), degtorad(-85)];
    instructions(6,:) = [double(h.left_arm(1)), degtorad(-85)];
    
    % Feet
    instructions(7,:) = [double(h.right_leg(5)), degtorad(-14)];
    instructions(8,:) = [double(h.left_leg(5)), degtorad(-14)];
    
elseif t < 2.6
    % Phase 4 Stand up
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-80)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(-80)];
    
    instructions(3,:) = [double(h.right_leg(4)), degtorad(60)];
    instructions(4,:) = [double(h.left_leg(4)), degtorad(60)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg(5)), degtorad(-10)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
    % Arms
    instructions(7,:) = [double(h.right_arm(1)), degtorad(-30)];
    instructions(8,:) = [double(h.left_arm(1)), degtorad(-30)];
else
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-20)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(-20)];
    
    instructions(3,:) = [double(h.right_leg(4)), degtorad(20)];
    instructions(4,:) = [double(h.left_leg(4)), degtorad(20)];
    
    % Feet
    instructions(5,:) = [double(h.right_leg(5)), degtorad(-10)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
    % Arms
    instructions(7,:) = [double(h.right_arm(1)), degtorad(-30)];
    instructions(8,:) = [double(h.left_arm(1)), degtorad(-30)];
end
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