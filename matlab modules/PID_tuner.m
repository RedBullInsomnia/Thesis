clear all

t = tcpip('127.0.0.1', 80, 'NetworkRole', 'server');
fopen(t);
disp('Blender connected')

i = 1;
data = zeros(0,0);
while i < 2
    % Read data
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            ang = char(data(1, 1:index(1)-1));
            angle(i) = str2num(ang);
            data = data(1,index(1)+1:end);
            i = i + 1;
        end
    end
end

angle

fclose(t);
delete(t);