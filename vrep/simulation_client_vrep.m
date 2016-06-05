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
    %instructions = go_prone(h, t);
    %positions(:, i) = get_joint_positions(vrep, id, h);
    
    %COM(i,:) = getCOM(vrep, clientID);
    %isInsideSupportArea(vrep, clientID, COM(i,:), h)
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

if t < 0.2
    
    % hips
    instructions(1,:) = [double(h.right_leg(3)), degtorad(30)];
    instructions(2,:) = [double(h.left_leg(3)), degtorad(30)];
    
    % feet
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-75)];
    instructions(4,:) = [double(h.left_leg(5)), degtorad(-75)];
    
    % right shoulder 
    instructions(5,:) = [double(h.right_arm(1)), degtorad(-100)];
    
    % left shoulder
    instructions(6,:) = [double(h.left_arm(1)), degtorad(-100)];
    
elseif t < 0.5
    
    % right shoulder 
    instructions(1,:) = [double(h.right_arm(2)), degtorad(70)];
    instructions(2,:) = [double(h.right_arm(3)), degtorad(70)];
    
    % left shoulder
    instructions(3,:) = [double(h.left_arm(2)), degtorad(-70)];
    instructions(4,:) = [double(h.left_arm(3)), degtorad(-70)];
    
elseif t < 0.9
    
    % right arm
    instructions(1,:) = [double(h.right_arm(2)), degtorad(80)];
    instructions(2,:) = [double(h.right_arm(3)), degtorad(40)];
    
    % left arm
    instructions(3,:) = [double(h.left_arm(2)), degtorad(-80)];
    instructions(4,:) = [double(h.left_arm(3)), degtorad(-40)];
    
    % Right leg
    instructions(5,:) = [double(h.right_leg(3)), degtorad(-40)];
    instructions(6,:) = [double(h.right_leg(5)), degtorad(-50)];
    
    % Left leg
    instructions(7,:) = [double(h.left_leg(3)), degtorad(-40)];
    instructions(8,:) = [double(h.left_leg(5)), degtorad(-50)];
    
elseif t < 1.4
    
    % Bring the knees in
    instructions(1,:) = [double(h.right_leg(4)), degtorad(80)];
    instructions(2,:) = [double(h.left_leg(4)), degtorad(80)];
    
    instructions(3,:) = [double(h.right_leg(3)), degtorad(-140)];
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-140)];
    
    % Use arms to lift trunk up
    % right arm
    instructions(5,:) = [double(h.right_arm(3)), degtorad(0)];
    
    % left arm
    instructions(6,:) = [double(h.left_arm(3)), degtorad(0)];
    
    % Feet
    instructions(7,:) = [double(h.right_leg(5)), degtorad(-30)];
    instructions(8,:) = [double(h.left_leg(5)), degtorad(-30)];
    
elseif t < 2
    
    % Feet
    instructions(1,:) = [double(h.right_leg(5)), degtorad(-14)];
    instructions(2,:) = [double(h.left_leg(5)), degtorad(-14)];
    
    % right arm
    instructions(3,:) = [double(h.right_arm(2)), degtorad(80)];
    
    % left arm 
    instructions(4,:) = [double(h.left_arm(2)), degtorad(-80)];

    % head
    instructions(5,:) = [double(h.head(1)), degtorad(-70)];
    
elseif t < 2.8
    
    % Time to stand
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-90)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(60)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-10)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-90)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(60)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
    % right arm
    instructions(7,:) = [double(h.right_arm(1)), degtorad(-15)];
    
    % left arm
    instructions(8,:) = [double(h.left_arm(1)), degtorad(-15)];
    
    % head
    instructions(9,:) = [double(h.head(1)), degtorad(0)];
    
elseif t < 3.2
    
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-70)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(50)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-10)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-70)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(50)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-10)];
    
else
    
    % right leg
    instructions(1,:) = [double(h.right_leg(3)), degtorad(-50)]; %-80
    instructions(2,:) = [double(h.right_leg(4)), degtorad(40)]; %60
    instructions(3,:) = [double(h.right_leg(5)), degtorad(-8)]; %-10
    
    % left leg
    instructions(4,:) = [double(h.left_leg(3)), degtorad(-50)];
    instructions(5,:) = [double(h.left_leg(4)), degtorad(40)];
    instructions(6,:) = [double(h.left_leg(5)), degtorad(-8)];
    
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