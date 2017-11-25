%% MATLAB Script for OILS Testing Pratham
% Authors: Akshay Khadse, Anant Joshi \m/
% Date: 13/01/2017

%% Clearing Workspace and Command Prompt
clear
clc 
tic
datetime = datestr(now, 'dd-mm-yy HH-MM');
% Initialize Log File
log_file_name = strcat(datetime, ' log_file.txt');
log_file = fopen(log_file_name,'wt');

curr_log_name = strcat(datetime, ' curr_log.mat');
x_log_name = strcat(datetime, ' x_log.mat');
mag_u_log_name = strcat(datetime, ' mag_u_log.mat');
mag_log_name = strcat(datetime, ' mag_log.mat');
sun_log_name = strcat(datetime, ' sun_log.mat');
gps_log_name = strcat(datetime, ' GPS_log.mat' );
mode_log_name = strcat(datetime, ' mode_log.mat' );
fprintf(log_file, 'OILS code started\n');

%% Initialize Serial
s = serial('COM5', 'BaudRate', 9600);
s.StopBits = 2;
set(s, 'Timeout', 10);
fprintf(log_file, 'Serial Configured\n');
fopen(s);
flushinput(s)
fprintf(log_file, 'Serial port opened\n');

% s_pf = serial('COM5', 'BaudRate', 9600);
% s_pf.StopBits = 2;
% set(s_pf, 'Timeout', 10);
% fprintf(log_file, 'Preflight Serial Configured\n');
% fopen(s_pf);
% flushinput(s_pf)
% fprintf(log_file, 'Preflight Serial port opened\n');

%% Initializing Constants
constants_v15;
fprintf(log_file, 'Constants Loaded\n');

%% OILS Part

% Initialize control input
%i_toEnvModel = [-0.178296013106502,0.492476060191519,0.163439674845768];
i_toEnvModel = [0.112499178,	-0.233374036,	-0.49247606];

i_fromOBC = i_toEnvModel;
fprintf(log_file, 'i_toEnvModel set to [0 0 0]\n');
fprintf(log_file, 'i_fromOBC set to [0 0 0]\n');

% Initialize Log File
curr_log = [i_fromOBC];
x_log = [];

% Initialize sensor data to 0
%MM_data_toOBC = [-504,1476,2937];
MM_data_toOBC = [1239 ,  2283 ,  1973];

fprintf(log_file, 'MM_data_toOBC set to ***\n');
%GPS_data_toOBC = [63,63,4,172,46,252,247,228,230,140,105,32,159,195,234,255,0,173,152,246,67,76,63,63,5,172,188,4,0,0,251,3,0,0,3,29,0,0,0,173,152,246,67,76,63,63,6,172,0,0,0,0,0,0,0,0,0,0,0,0,67,76,63,63,8,172,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,67,76,63,63,10,172,12,12,12,12,12,12,12,12,67,76,63,63,11,172,12,12,118,0,0,173,152,246,67,76,63,63,14,172,117,117,117,117,10,0,0,0,40,0,0,0,126,187,158,255,67,76,63,63,15,172,16,58,16,18,10,223,7,67,76,10,10];
GPS_data_toOBC = [63,63,4,172,152,132,251,228,57,126,108,32,189,76,0,0,2,173,152,246,67,76,63,63,5,172,198,4,0,0,240,3,0,0,3,29,0,0,2,173,152,246,67,76,63,63,6,172,0,0,0,0,0,0,0,0,0,0,0,0,67,76,63,63,8,172,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,67,76,63,63,10,172,134,134,134,134,134,134,134,134,67,76,63,63,11,172,134,134,103,0,2,173,152,246,67,76,63,63,14,172,92,92,92,92,168,0,0,0,39,0,0,0,9,176,158,255,67,76,63,63,15,172,16,58,18,18,10,223,7,67,76,10,10];

fprintf(log_file, 'GPS_data_toOBC set t0 ***\n');
%sun_toOBC = [0.844200244200244,0.159706959706960,0.159706959706960,4.07203907203907,3.19706959706960,0.159706959706960];
sun_toOBC = [0.521994134897361,0,0,1.82795698924731,2.69696969696970,0];

fprintf(log_file, 'sun_toOBC set to ***\n\n');
MM_data_storage = [];
MM_data_storage_u = [];
GPS_data_storage = [];
sun_data_storage = [];
mode=[];
curr_log = [];
x_log = [];
curr_control_log = [];
MM_data_ack_storage_OBC = [];
MM_data_ack_storage_pf = [];

%% Begin Loop
fwrite(s, 60, 'uint8');
pause(0.1);
fprintf(log_file, 'Send Simulink Ready Code 60\n');
fprintf(log_file, '######## Loop Started ########\n');
for i = 1:2
    MM_data_matched = 0;
    i_toEnvModel = i_fromOBC;
    fprintf(log_file, '# Iteration number: %d\n', i);
    
    % Calculate times for each simulation
    t_start = (i-1)*2;
    t_stop = i*2;
    fprintf(log_file, '# Start Time: %f \t Stop Time: %f\n', t_start, t_stop);
    
    % Serial send data to OBC
    for j = 1:3
        temp = [];
        temp = fread(s, 1, 'uint8')
        fprintf(log_file, '# Poll Code recieved: %d\n', temp);
        temp == 80
        
        if temp(1) == 80
            
            % Code to send Magnetometer data
            %for iter = 1: 3
            %    fwrite(s, fliplr(typecast(int16(MM_data_toOBC(iter)), 'uint8'))); %Little Endian
            %    fliplr(typecast(int16(MM_data_toOBC(iter)), 'uint8'))
            %end
            MM_data_toOBC2 = [];
            for iter = 1: 3
                MM_data_toOBC2 = [MM_data_toOBC2 fliplr(typecast(int16(MM_data_toOBC(iter)), 'uint8'))];
            end
            while ~MM_data_matched
                MM_data_matched = 1;
                %fwrite(s, MM_data_toOBC2);
                fwrite(s, uint8([4,215,8,235,7,181]));
                MM_data_ack = fread(s, 6, 'uint8');
                for k = 1:6
                    if MM_data_ack(k) ~= MM_data_toOBC2(k);
                        MM_data_matched = 0;
                    end
                end
                fwrite(s, MM_data_matched);
                if(MM_data_matched)
                    fprintf('MM Data Matched')
                end
            end
            
            fprintf(log_file, '# MM data sent to OBC: ');
            fprintf(log_file, '%d ', MM_data_toOBC2);
            fprintf(log_file, '\n');
            
            fprintf(log_file, '# MM data ack. by OBC: ');
            fprintf(log_file, '%d ', MM_data_ack);
            fprintf(log_file, '\n');
            MM_data_storage = [MM_data_storage; i, double(MM_data_toOBC)];
            MM_data_storage_u = [MM_data_storage_u; i, double(MM_data_toOBC2)];
            MM_data_ack_storage_OBC = [MM_data_ack_storage_OBC; i, double(MM_data_ack')];
            
            %fwrite(s_pf, MM_data_toOBC2);
            %MM_data_ack_2 = fread(s_pf, 6, 'uint8');
            %MM_data_ack_storage_pf = [MM_data_ack_storage_pf; i, double(MM_data_ack_2')];
            % Get i_fromOBC serially
            i_temp = [];
            i_temp = fread(s, 9, 'uint8');
            i_fromOBC = [];
            for iter = [1 4 7]
                if i_temp(iter) == 0
                    i_fromOBC = [i_fromOBC, (double(i_temp(iter+1))+256*double(i_temp(iter+2)))*3.6/(13.2*65535)];
                else
                    i_fromOBC = [i_fromOBC, (double(i_temp(iter+1))+256*double(i_temp(iter+2)))*-3.6/(13.2*65535)];
                end
            end
            fprintf(log_file, '# Current recieved from OBC: %f %f %f\n', i_fromOBC);
            curr_log = [curr_log; i, double(i_fromOBC)];
            
            flag = fread(s, 1, 'uint8');
            if flag == 4
                fprintf(log_file, '# Detumbling mode\n');
            elseif flag == 14
                fprintf(log_file, '# Nominal mode\n');
            end
            mode = [mode; i, flag];
        elseif temp(1) == 100
            % Code to send sun sensor data
            %for iter = 1: 6
            %    fwrite(s, typecast(int16(sun_toOBC(iter)), 'uint8'));
            %    % Check if OBC is expecting Big Endian data
            %    typecast(int16(sun_toOBC(iter)), 'uint8')
            %end
            Sun_toOBC2 = [];
            for iter = 1: 6
                Sun_toOBC2 = [Sun_toOBC2 typecast(int16(sun_toOBC(iter)), 'uint8')];
            end
            fwrite(s, Sun_toOBC2);
            sun_data_storage = [sun_data_storage; i, double(Sun_toOBC2)];
            fprintf(log_file, '# Sun Sensor data sent to OBC: ');
            fprintf(log_file, '%d ', Sun_toOBC2);
            fprintf(log_file, '\n');
            Sun_data_ack = fread(s, 12, 'uint8');
            fprintf(log_file, '# Sun Sensor data ack. by OBC: ');
            fprintf(log_file, '%d ', Sun_data_ack);
            fprintf(log_file, '\n');
            
        elseif temp(1) == 90
             % Code to send GPS data
             for iter = 1: 155
                 fwrite(s, GPS_data_toOBC(iter), 'uint8');
             end
             GPS_data_storage = [GPS_data_storage; i, double(GPS_data_toOBC)];
             fprintf(log_file, '# GPS data sent to OBC\n');
        else
             GPS_data_storage = [GPS_data_storage; i, double(GPS_data_toOBC)];
             fprintf(log_file, '# GPS data NOT sent to OBC\n');
        end
        
    end
    
    % Post processing
    % Simulate over 2 sec window
    fprintf(log_file, '# Simulating...\n');
    simOut = sim('OILS_model.mdl');
    
    % Update values of i and x
    q_BI0 = x_fromEnvModel(1:4)';
    x_log = [x_log; x_fromEnvModel];
    wx0 = x_fromEnvModel(5);
    wy0 = x_fromEnvModel(6);
    wz0 = x_fromEnvModel(7);
    curr_control_log = [curr_control_log; curr_control_law];
    fprintf(log_file, '# Time Elapsed: %f\n\n', toc);
end
%%
fclose(s);
%fclose(s_pf);
save(curr_log_name, 'curr_log');
save(x_log_name , 'x_log');
save(mag_u_log_name , 'MM_data_storage_u');
save(mag_log_name, 'MM_data_storage');
save(sun_log_name, 'sun_data_storage');
save(gps_log_name, 'GPS_data_storage');
save(mode_log_name, 'GPS_data_storage');

fprintf(log_file, '######## Finished ########\n');