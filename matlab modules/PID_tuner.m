clear all

t = tcpip('127.0.0.1', 80, 'NetworkRole', 'server');
fopen(t);
disp('Blender connected')

count = 0;
data = zeros(0,0);
while count < 4
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            info = char(data(1, 1:index(1)-1));
            infos(count + 1) = str2double(info);
            data = data(1, index(1)+1:end);
            count = count + 1;
        end
    end
end

d_angle = infos(1);
kp = infos(2);
ki = infos(3);
kd = infos(4);

i = 1;
while i < 1201
    % Read data
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            ang = char(data(1, 1:index(1)-1));
            angle(i) = str2double(ang);
            data = data(1,index(1)+1:end);
            i = i + 1;
        end
    end
end

figure
dt = 1/60;
x = 0:dt:(i-2)*dt;
plot(x, angle)
hold on
plot(get(gca, 'xlim'), [d_angle d_angle], 'r--');
str = sprintf ('Kp = %f, Ki = %f, Kd = %f', kp, ki, kd);
title(str)

fclose(t);
delete(t);