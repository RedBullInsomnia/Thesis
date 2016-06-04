function reset_robot_position(vrep, id, h, configuration)
    if strcmp(configuration, 'prone')
        
        vrep.simxSetObjectOrientation(id, h.center, -1, ...
            [degtorad(-90), 0, degtorad(-90)], vrep.simx_opmode_oneshot_wait);
        vrep.simxSetObjectPosition(id, h.center, -1, ...
            [0, 0, 0.1], vrep.simx_opmode_oneshot_wait);
        
    elseif strcmp(configuration, 'supine')
        
        vrep.simxSetObjectOrientation(id, h.center, -1, ...
            [degtorad(90), 0, degtorad(-90)], vrep.simx_opmode_oneshot_wait);
        vrep.simxSetObjectPosition(id, h.center, -1, ...
            [0, 0, 0.1], vrep.simx_opmode_oneshot_wait);
        
    elseif strcmp(configuration, 'stand')
        
        vrep.simxSetObjectOrientation(id, h.center, -1, ...
            [degtorad(-180), 0, degtorad(-90)], vrep.simx_opmode_oneshot_wait);
        vrep.simxSetObjectPosition(id, h.center, -1, ...
            [0, 0, 0.43], vrep.simx_opmode_oneshot_wait);
        
    end
end