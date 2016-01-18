clear all

t = tcpip('127.0.0.1', 80, 'NetworkRole', 'server');
fopen(t);
disp('Blender connected')

msg = 'Cylinder.008:-40000 Cylinder.009:-40000\n';

count = 0;
fwrite(t, msg);
i = 0;
data = zeros(0,0);
while count < 1790
    % Send order
    
    % Read data
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)'];
        index = find(data==13);
        if 0 == isempty(index)
            %fprintf(char(data))
            data = data(1,index(1)+1:end);
            i = i + 1;
            disp(count);
            msg = strcat('Cylinder.008:',int2str(i),' Cylinder.009:',int2str(i),'\n');
            fwrite(t, msg);
            count = count + 1;
        end
    end
end
fclose(t);
delete(t);