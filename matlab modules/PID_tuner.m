clear all
num_servos = 1;

!"C:/Program Files/Blender Foundation/Blender/blenderplayer.exe" "C:/Users/Hubert/Repos/Thesis/1servo_pid.blend" &

t = tcpip('127.0.0.1', 80, 'NetworkRole', 'server');
fopen(t);
disp('Blender connected')

count = 0;
data = zeros(0,0);
while count < 5
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            info = char(data(1, 1:index(1)-1));
            disp(info)
            infos(count + 1) = str2double(info);
            data = data(1, index(1)+1:end);
            count = count + 1;
        end
    end
end

d_angle(1) = infos(1);
d_angle(2) = infos(2);
kp = infos(3);
ki = infos(4);
kd = infos(5);

i = 0;
while i < 1000
    % Read data
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            ang = char(data(1, 1:index(1)-1));
            angle(i+1) = str2double(ang);
            data = data(1,index(1)+1:end);
            i = i + 1;
        end
    end
end

if num_servos == 2
	angle1 = angle(1:2:end);
    angle2 = angle(2:2:end);
    figure
    dt = 1/60;
    x = 0:dt:((i-1)/2)*dt;
    plot(x, angle1)
    hold on
    plot(get(gca, 'xlim'), [d_angle(1) d_angle(1)], 'r--');
    str = sprintf ('Kp = %f, Ki = %f, Kd = %f', kp, ki, kd);
    title(str)

    figure
    dt = 1/60;
    x = 0:dt:(i-1)*dt/2;
    plot(x, angle2)
    hold on
    plot(get(gca, 'xlim'), [d_angle(2) d_angle(2)], 'r--');
    str = sprintf ('Kp = %f, Ki = %f, Kd = %f', kp, ki, kd);
    title(str)
else
    figure
    dt = 1/60;
    x = 0:dt:(i-1)*dt;
    plot(x, angle)
    hold on
    plot(get(gca, 'xlim'), [d_angle(1) d_angle(1)], 'r--');
    str = sprintf ('Kp = %f, Ki = %f, Kd = %f', kp, ki, kd);
    title(str)
end

fclose(t);
delete(t);