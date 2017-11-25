clc
clear

s = serial('COM9', 'BaudRate', 9600);
s.StopBits = 2;
set(s, 'Timeout', 10);
%%
fopen(s)
%for iter = 1: 173
%    fwrite(s, 0, 'uint8');
%end

%a = [];
%while length(a) ~= 6
%    a = fread(s);
%end
%fclose(s)
%a

%% 
flushinput(s)
fwrite(s, 60, 'uint8');
pause(5)
fscanf(s, '%u', 2)

