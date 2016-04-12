function stable = isInsideSupportArea( vrep, id, point, h )
%GETSTATICSTABILITY Returns a 1 if point is inside the supporting polygon,
%0 otherwise

f_len = 0.09/2; %cm
f_width = 0.06/2; 
f_depth = 0.0226 + 0.002; % treshold used to detect when a foot is on ground

[~, l_foot] = vrep.simxGetObjectPosition(id, h.left_leg(5), -1,...
    vrep.simx_opmode_oneshot_wait);
[~, r_foot] = vrep.simxGetObjectPosition(id, h.right_leg(5), -1,...
    vrep.simx_opmode_oneshot_wait);

polyg = 0;
if l_foot(3) <= f_depth && r_foot(3) <= f_depth
    polyg = [l_foot(1) + f_width, l_foot(2) + f_len;
        l_foot(1) - f_width, l_foot(2) + f_len;
        r_foot(1) + f_width, r_foot(2) + f_len;
        r_foot(1) - f_width, r_foot(2) + f_len;
        r_foot(1) - f_width, r_foot(2) - f_len;
        r_foot(1) + f_width, r_foot(2) - f_len;
        l_foot(1) - f_width, l_foot(2) - f_len;
        l_foot(1) + f_width, l_foot(2) - f_len;
        l_foot(1) + f_width, l_foot(2) + f_len
        ];
elseif l_foot(3) <= f_depth
    polyg = [l_foot(1) + f_width, l_foot(2) + f_len;
        l_foot(1) - f_width, l_foot(2) + f_len;
        l_foot(1) - f_width, l_foot(2) - f_len;
        l_foot(1) + f_width, l_foot(2) - f_len;
        l_foot(1) + f_width, l_foot(2) + f_len
        ];
elseif r_foot(3) <= f_depth
    polyg = [r_foot(1) + f_width, r_foot(2) + f_len;
        r_foot(1) - f_width, r_foot(2) + f_len;
        r_foot(1) - f_width, r_foot(2) - f_len;
        r_foot(1) + f_width, r_foot(2) - f_len;
        r_foot(1) + f_width, r_foot(2) + f_len
        ];
end

if polyg ~= 0
    stable = inpolygon(point(1), point(2), polyg(:,1), polyg(:,2));
else
    stable = 0;
    
end

