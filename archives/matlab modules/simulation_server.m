%% Matlab script that communicates with blender through a socket
clear all;

% Setting up the socket
t = tcpip('127.0.0.1', 80, 'NetworkRole', 'server');
fopen(t);
disp('Blender connected')

% Messages handling
msg = 'Cylinder.008:-40000 Cylinder.009:-40000\n';
data = zeros(0,0); % our buffer

fwrite(t, msg);
i = 0;
while i < 1790
    % Read data
    incoming = get(t, 'BytesAvailable');
    if (incoming > 0)
        data = [data, fread(t, incoming)']; % add to buffer
        index = find(data==13); % dirty fix, look for '\r'
        if 0 == isempty(index)
            data = data(1, index(1) + 1:end);
            i = i + 1;
            disp(i);
            % Send 'order', currently simple string
            msg = strcat('Cylinder.008:',int2str(i),' Cylinder.009:',int2str(i),'\n');
            fwrite(t, msg);
        end
    end
end

% Neatly dispose of socket
fclose(t);
delete(t);
