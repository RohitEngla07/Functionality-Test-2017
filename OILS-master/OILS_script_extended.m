%% MATLAB Script for OILS Testing Pratham
% Authors: Akshay Khadse, Anant Joshi \m/
% Date: 13/01/2017
%%
clear
clc
%%
delete(instrfindall)
tic

% Initialize Log File
datetime = datestr(now, 'dd-mm-yy HH-MM');
fpath = fullfile('Logs',datetime); 
mkdir(fpath);
log_file_name = fullfile(fpath, ' log_file.txt');
log_file = fopen(log_file_name,'wt');
fprintf(log_file, datetime);
curr_control_log_name = fullfile(fpath, ' curr_control_log.csv');
curr_log_name = fullfile(fpath, ' curr_log.csv');
x_log_name = fullfile(fpath, ' x_log.csv');
mag_u_log_name = fullfile(fpath, ' mag_u_log.csv');
mag_log_name = fullfile(fpath, ' mag_log.csv');
sun_log_name = fullfile(fpath, ' sun_log.csv');
gps_log_name = fullfile(fpath, ' GPS_log.csv' );
mode_log_name = fullfile(fpath, ' mode_log.csv' );
fprintf(log_file, 'OILS code started\n');
%Initial conditions for t=0
% MM_data_toOBC = [-504,1476,2937];
% GPS_data_toOBC = [63,63,4,172,46,252,247,228,230,140,105,32,159,195,234,255,0,173,152,246,67,76,63,63,5,172,188,4,0,0,251,3,0,0,3,29,0,0,0,173,152,246,67,76,63,63,6,172,0,0,0,0,0,0,0,0,0,0,0,0,67,76,63,63,8,172,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,117,67,76,63,63,10,172,12,12,12,12,12,12,12,12,67,76,63,63,11,172,12,12,118,0,0,173,152,246,67,76,63,63,14,172,117,117,117,117,10,0,0,0,40,0,0,0,126,187,158,255,67,76,63,63,15,172,16,58,16,18,10,223,7,67,76,10,10];
% sun_toOBC = [1,0,0,0,0,0,4,0,3,0,0,0];
% MM_data_toOBC_raw = [-4.32742099276996e-06,8.97702298176241e-06,1.93199513687597e-05];
% i_toEnvModel = [-0.178296013106502,0.492476060191519,0.163439674845768];
% i_fromOBC = i_toEnvModel;
% t_init = 0;
% B_k_init = [0,0,0];
%%Simulation Continued
%Instructions - if sim needs to be continued from from time 't', put MM,
%GPS, Sun data to OBC, x data from respective logs at time 't'. 
%put t_init =  t. B_k_init shold be at t_init - 2
% GPS_data_toOBC = [63,63,4,172,240,94,43,224,167,217,66,251,43,93,169,228,218,23,153,246,67,76,63,63,5,172,96,17,0,0,172,9,0,0,13,234,255,255,218,23,153,246,67,76,63,63,6,172,0,0,0,0,0,0,0,0,0,0,0,0,67,76,63,63,8,172,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,67,76,63,63,10,172,134,134,134,134,134,134,134,134,67,76,63,63,11,172,134,134,1,0,218,23,153,246,67,76,63,63,14,172,92,92,92,92,84,255,255,255,29,0,0,0,23,159,158,255,67,76,63,63,15,172,24,34,10,18,10,223,7,67,76,10,10];
% sun_toOBC = [0,0,0,0,0,0,0,0,0,0,0,0];
% MM_data_toOBC_raw = [-8.21571969700000e-07,-2.02047175300000e-05,-2.28628321400000e-05];
% i_fromOBC_init1 = [0.00469006845800000,-0.00325017166400000,0.0135458498900000];
% i_fromOBC_init2 = [0.00378701179800000,-0.00394931230400000,0.0136249193700000];
% t_init = 27354;
% B_k_init = [1.38373905100000e-06,-2.08492871500000e-05,-2.22438513700000e-05];
%MM_data_toOBC_timeseries = [-649,1347,2898];
%  GPS_data_toOBC = [63,63,4,172,0,203,113,246,125,89,23,10,103,3,202,39,46,37,7,146,67,76,63,63,5,172,221,26,0,0,8,247,255,255,183,8,0,0,46,37,7,146,67,76,63,63,6,172,0,0,0,0,0,0,0,0,0,0,0,0,67,76,63,63,8,172,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,92,67,76,63,63,10,172,134,134,134,134,134,134,134,134,67,76,63,63,11,172,134,134,1,0,46,37,7,146,67,76,63,63,14,172,92,92,92,92,176,0,0,0,237,255,255,255,4,146,158,255,67,76,63,63,15,172,29,53,26,18,10,223,7,67,76,10,10];
%  sun_toOBC = [0,0,0,0,0,0,3,0,0,0,2,0];
%  i_toEnvModel = [0.083222705424582,0.009975238769013,-0.207911109261533];
%  i_fromOBC = i_toEnvModel;

fprintf(log_file, 'i_toEnvModel set to [0 0 0]\n');
fprintf(log_file, 'i_fromOBC set to [0 0 0]\n');
cont1 = 0; cont2 = 1;
%% Initialize Serial
s = serial('COM11', 'BaudRate', 9600);
s.StopBits = 2;
set(s, 'Timeout', 130);
fprintf(log_file, 'Serial Configured\n');
fopen(s);
flushinput(s)
fprintf(log_file, 'Serial port opened\n');

%% Initializing Constants
constants_v15;
cont1 = 1;

%initial conditions for detecting OBC failure
if cont1 ==1
    load sim_cont.mat
%     today = datenum('18-Oct-2010 10:30:0')+ seconds(t_init);
%     today = datenum(today);
%     w_simcont = [-0.0160749715300000,-0.0280692349800000,0.0218096922600000];
%     q_BI0 = [0.347215535500000,-0.681808374100000,-0.180995026300000,0.617915458100000]';

    % today = datenum('18-Oct-2010 10:30:0')+ seconds(8);
    % today = datenum(today);
    % w = [-0.000119983544900000,0.0301140893600000,0.00948666020900000];
    % q_BI0 = [0.0279861165400000,-0.221949462100000,0.614858395100000,0.756243590100000]';

    wx0 = w_simcont(1);
    wy0 = w_simcont(2);    
    wz0 = w_simcont(3);

    euler_101 = [atan2( 2*( q_BI0(4)*q_BI0(1)-q_BI0(2)*q_BI0(3) ),( 1 - 2*( q_BI0(1)^2 + q_BI0(2)^2 ) )  ) ;
                  asin( 2*(q_BI0(4)*q_BI0(2)+q_BI0(3)*q_BI0(1)) );
                 atan2( 2*( q_BI0(4)*q_BI0(3)-q_BI0(1)*q_BI0(2) ),( 1 - 2*( q_BI0(2)^2 + q_BI0(3)^2 ) )  ) ];

    roll0   = euler_101(1);                
    pitch0  = euler_101(2);    
    yaw0    = euler_101(3);
end
         
fprintf(log_file, 'Constants Loaded\n');

fwrite(s, 60, 'uint8');
fprintf(log_file, 'Send Simulink Ready Code 60\n');
slave_i = 300;
for master_i=1:50
    
    % Initialize Log File
    curr_log = [];
    curr_control_log = [];
    x_log = [1, q_BI0', wx0, wy0, wz0];
    MM_data_storage = [];
    MM_data_storage_u = [];
    MM_data_ack_storage_OBC = [];
    MM_data_ack_storage_pf = [];
    GPS_data_storage = [];
    sun_data_storage = [];
    mode=[];
    MM_data_toCL_raw1_log = [];
    MM_data_toCL_raw2_log = [];
    B_avg_log = [];
    B_avg_OBC_log = [];
    dB_log = [];
    dB_OBC_log = [];
    %% Begin Loop
    fprintf(log_file, '######## Loop Started ########\n');
    for i = (1+slave_i*(master_i-1)):(slave_i*master_i)
        i
        MM_data_matched = 0;
        i_data_matched = 0;
        B_avg_data_matched = 0;
        dB_data_matched = 0;
        %i_toEnvModel = i_fromOBC;
        fprintf(log_file, '# Iteration number: %d\n', i);

        % Calculate times for each simulation
        t_start = t_init +(i-1)*2;
        t_stop = t_start + 2;
        fprintf(log_file, '# Start Time: %f \t Stop Time: %f\n', t_start, t_stop);

        % Serial send data to OBC
        for j = 1:3
            temp = [];
            temp = fread(s, 1, 'uint8')
            fprintf(log_file, '# Poll Code recieved: %d\n', temp);
            

            if temp(1) == 80

                % Code to send Magnetometer data
                %for iter = 1: 3
                %    fwrite(s, fliplr(typecast(int16(MM_data_toOBC(iter)), 'uint8'))); %Little Endian
                %    fliplr(typecast(int16(MM_data_toOBC(iter)), 'uint8'))
                %end
                X = int16( abs(MM_data_toOBC_raw(1)) * 30000 * 1e4 / 2.0);
                Y = int16( abs(MM_data_toOBC_raw(2)) * 30000 * 1e4 / 2.0);
                Z = int16( abs(MM_data_toOBC_raw(3)) * 30000 * 1e4 / 2.0);
                XYZ = [X Y Z];
                MM_data_toOBC2 = [];
                for iter = 1: 3
                    MM_data_toOBC2 = [MM_data_toOBC2 fliplr(typecast(int16(XYZ(iter)), 'uint8'))];
                end
                for iter = 1:3
                    if MM_data_toOBC_raw(iter)>=0
                        MM_data_toOBC2 = [MM_data_toOBC2, uint8(0)];
                    else
                        MM_data_toOBC2 = [MM_data_toOBC2, uint8(1)];
                    end
                end
                while ~MM_data_matched
                    MM_data_matched = 1;
                    fwrite(s, MM_data_toOBC2);
                    MM_data_ack = fread(s, 9, 'uint8');
                    for k = 1:9
                        if MM_data_ack(k) ~= MM_data_toOBC2(k);
                            MM_data_matched = 0;
                        end
                    end
                    fwrite(s, MM_data_matched);
                    if(MM_data_matched)
                        fprintf('MM Data Matched\n')
                    end
                end

                fprintf(log_file, '# MM data sent to OBC: ');
                fprintf(log_file, '%d ', MM_data_toOBC2);
                fprintf(log_file, '\n');

                fprintf(log_file, '# MM data ack. by OBC: ');
                fprintf(log_file, '%d ', MM_data_ack);
                fprintf(log_file, '\n');
                MM_data_storage = [MM_data_storage; i, double(MM_data_toOBC_raw)];
                MM_data_storage_u = [MM_data_storage_u; i, double(MM_data_toOBC2)];
                MM_data_ack_storage_OBC = [MM_data_ack_storage_OBC; i, double(MM_data_ack')];

                %fwrite(s_pf, MM_data_toOBC2);
                %MM_data_ack_2 = fread(s_pf, 6, 'uint8');
                %MM_data_ack_storage_pf = [MM_data_ack_storage_pf; i, double(MM_data_ack_2')];
                % Get i_fromOBC serially
                while ~i_data_matched
                    i_temp = [];
                    i_temp = fread(s, 9, 'uint8');
                    fwrite(s,i_temp);
                    i_data_matched = fread(s,1, 'uint8');
                    if(i_data_matched)
                        fprintf('I Data Matched\n')
                        fprintf(log_file, '# Current Data Matched\n');
                    end
                end
                i_fromOBC = [];
                for iter = [1 4 7]
                    if i_temp(iter) == 0
                        i_fromOBC = [i_fromOBC, (double(i_temp(iter+1))+256*double(i_temp(iter+2)))*3.6/(13.2*65535)];
                    else
                        i_fromOBC = [i_fromOBC, (double(i_temp(iter+1))+256*double(i_temp(iter+2)))*-3.6/(13.2*65535)];
                    end
                end
%                 fprintf(log_file, '# Current recieved from OBC: %f %f %f\n', i_fromOBC);
%                 curr_log = [curr_log; i, double(i_fromOBC)];
                if cont1==1
                    if cont2 == 2
                        i_fromOBC = i_fromOBC_init2
                        cont1 = 0;
                    end
                    if cont2 == 1
                        i_fromOBC = i_fromOBC_init1
                        cont2 = 2;
                    end
                    
                end
                fprintf(log_file, '# Current recieved from OBC: %f %f %f\n', i_fromOBC);
                curr_log = [curr_log; i, double(i_fromOBC)];
                i_toEnvModel(1) = i_fromOBC(3);
                i_toEnvModel(2) = i_fromOBC(2);
                i_toEnvModel(3) = i_fromOBC(1);
                
                flag = fread(s, 1, 'uint8');
                if flag == 4
                    fprintf(log_file, '# Detumbling mode\n');
                elseif flag == 14
                    fprintf(log_file, '# Nominal mode\n');
                end
                mode = [mode; i, flag];
                
                B_avg_fromOBC = [];
                dB_fromOBC = [];
                %Bt = fread(s, 1, 'uint8');
                
                while( ~( B_avg_data_matched) && ~(i==1) )
                    B_avg_temp = [];
                    B_avg_temp = fread(s, 9, 'uint8');
                    fwrite(s,B_avg_temp);
                    B_avg_data_matched = fread(s,1, 'uint8');
                    if(B_avg_data_matched)
                        fprintf('BAvg Data Matched\n')
                        fprintf(log_file, '# BAvg Data Matched\n');
                    end
                end
                
                if ~(i==1)
                    for iter = [7 8 9]
                        if B_avg_temp(iter) == 0
                            iter = 1 + (iter-7)*2;
                            B_avg_fromOBC = [B_avg_fromOBC, (double(B_avg_temp(iter))+256*double(B_avg_temp(iter+1)))];
                        else
                            iter = 1 + (iter-7)*2;
                            B_avg_fromOBC = [B_avg_fromOBC, (double(B_avg_temp(iter))+256*double(B_avg_temp(iter+1)))*(-1)];
                        end
                    end
                    
                    B_avg_OBC_log = [B_avg_OBC_log; i, B_avg_fromOBC/15e7];
                end
                
                
                while( ~( dB_data_matched) && ~(i==1) )
                    dB_temp = [];
                    dB_temp = fread(s, 9, 'uint8');
                    fwrite(s,dB_temp);
                    dB_data_matched = fread(s,1, 'uint8');
                    if(dB_data_matched)
                        fprintf('dB Data Matched\n')
                        fprintf(log_file, '# dB Data Matched\n');
                    end
                end
                
                if ~(i==1)
                    for iter = [7 8 9]
                        if dB_temp(iter) == 0
                            iter = 1 + (iter-7)*2;
                            dB_fromOBC = [dB_fromOBC, (double(dB_temp(iter))+256*double(dB_temp(iter+1)))];
                        else
                            iter = 1 + (iter-7)*2;
                            dB_fromOBC = [dB_fromOBC, (double(dB_temp(iter))+256*double(dB_temp(iter+1)))*(-1)];
                        end
                    end
                    
                    dB_OBC_log = [dB_OBC_log; i, dB_fromOBC/15e7];
                end
                
                
            elseif temp(1) == 100
                % Code to send sun sensor data
                %for iter = 1: 6
                %    fwrite(s, typecast(int16(sun_toOBC(iter)), 'uint8'));
                %    % Check if OBC is expecting Big Endian data
                %    typecast(int16(sun_toOBC(iter)), 'uint8')
                %end
                if i ==1
                    Sun_toOBC2 = sun_toOBC;
                else
                    Sun_toOBC2 = [];
                    for iter = 1: 6
                        Sun_toOBC2 = [Sun_toOBC2 typecast(int16(sun_toOBC(iter)), 'uint8')];
                    end
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
                 GPS_temp = zeros(1,151);
                 for iter = 1: 151
                     fwrite(s, GPS_data_toOBC(iter), 'uint8');
                     GPS_temp(iter) = double(GPS_data_toOBC(iter));
                 end
                 fprintf(log_file, '# GPS data sent to OBC\n');
                 ISR_count = fread(s, 1, 'uint8');
                 GPS_done = fread(s, 1, 'uint8');
                 
                 if GPS_done==90
                     fprintf(log_file, '# GPS done\n');
                 end
                 GPS_data_storage = [GPS_data_storage; i, GPS_temp, ISR_count, 90];
            else
                 GPS_temp = zeros(1,151);
                 for iter = 1: 151
                     GPS_temp(iter) = double(GPS_data_toOBC(iter));
                 end
                 GPS_data_storage = [GPS_data_storage; i, GPS_temp, 0, 91];
                 fprintf(log_file, '# GPS data NOT sent to OBC\n');
            end

        end

        % Post processing
        % Simulate over 2 sec window
        fprintf(log_file, '# Simulating...\n');
        simOut = sim('OILS_model.mdl');
        MM_data_toCL_raw1_log = [MM_data_toCL_raw1_log; i, MM_data_toCL_raw1(1,:),MM_data_toCL_raw1(2,:)];
        MM_data_toCL_raw2_log = [MM_data_toCL_raw2_log; i, MM_data_toCL_raw2(1,:),MM_data_toCL_raw2(2,:)];
        B_avg_log = [B_avg_log; i, B_avg(1,:), B_avg(2,:)];
        dB_log = [dB_log; i, dB(1,:), dB(2,:)];
        x_log = [x_log; i+1, x_fromEnvModel];
        % Update values of i and x
        q_BI0 = x_fromEnvModel(1:4)';
        %x_log = [x_log; x_fromEnvModel];
        wx0 = x_fromEnvModel(5);
        wy0 = x_fromEnvModel(6);
        wz0 = x_fromEnvModel(7);
        B_k_init = MM_data_toCL_raw1(1,:);
        curr_control_log = [curr_control_log; curr_control_law];
        fprintf(log_file, '# Time Elapsed: %f\n\n', toc);
    end

    %%
    
    dlmwrite(curr_control_log_name,curr_control_log,'delimiter',',','-append', 'precision', 10);
    dlmwrite(curr_log_name,curr_log,'delimiter',',','-append', 'precision', 10);
    dlmwrite(x_log_name,x_log,'delimiter',',','-append', 'precision', 10);
    dlmwrite(mag_u_log_name,MM_data_storage_u,'delimiter',',','-append', 'precision', 10);
    dlmwrite(mag_log_name,MM_data_storage,'delimiter',',','-append', 'precision', 10);
    dlmwrite(sun_log_name,sun_data_storage,'delimiter',',','-append', 'precision', 10);
    dlmwrite(gps_log_name,GPS_data_storage,'delimiter',',','-append', 'precision', 10);
    dlmwrite(mode_log_name,mode,'delimiter',',','-append', 'precision', 10);
    %
    MM_data_toOBC = MM_data_storage(size(MM_data_storage, 1), 2:end);
    GPS_data_toOBC = GPS_data_storage(size(GPS_data_storage, 1), 2:end);
    sun_toOBC = sun_data_storage(size(sun_data_storage, 1), 2:end);
    i_toEnvModel = curr_log(size(curr_log, 1), 2:end);
    i_fromOBC = i_toEnvModel;
end
%%
fclose(s);
fprintf(log_file, '######## Finished ########\n');
fclose('all');