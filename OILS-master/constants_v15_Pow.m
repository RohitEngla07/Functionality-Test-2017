%% This is the input file for the PRATHAM ADCS simulations.
% run this file before running the SIMULINK model.

% NEEDS THE FOLLOWING FILES:
    % euler_to_rotmatrix.m
    % rotmatrix_to_quaternion.m
    % rotate_x.m
    % rotate_y.m
    % rotate_z.m
    % sh2010.mat
    % light_calc.m
    % sun_calc.m
    % euler2qBI.m

% THE FOLLOWING MAT FILES NEED TO BE SAVED BEFORE SIMULATING:
    % Bi_120k.mat
    % Bi8_est_120k.mat
    % SGP_120k.mat
    % SGP_est_120k.mat     %%% run precalc.m to calculate upto here
    % light_120k.mat       %%% run light_calc.m to generate this file
    % Si_120k.mat          %%% run sun_calc.m to generate this file
    

%% CHECK THESE ALWAYS
% Date and time
% Tolerance values
% Initial angular rates and euler angles
% Moment of inertia
% v_COM_to_COP_b 
% Rest all values are pretty much constant

clear;
clc;
close all;

%% Configuration Parameters
s_SIM_STEP_SIZE = 0.1;  % integration step size
Ts_display = 6;     % sample time for data logging
%%ext = 'jpg';

%% TIME
today = datenum('18-Oct-2015 10:30:0'); % ** SGP, IGRF data have been created for this date **
equinox = datenum('20-Mar-2015 12:0:0'); % date of equinox

%% SGP (Orbit parameters / ICs)
R_e = 6378164 + 700000;    % Earth radius + Height of sat
mu=6.673e-11*5.9742e24;    % G*M_earth, SI ??????
s_W_SAT =sqrt(mu/R_e^3); % angular velocity of revolution of satellite in rad/sec
T_ORBIT = 2*pi/s_W_SAT;  % orbital period

%% Inertia
% GG stability condition: Iyy > Ixx > Izz
Ixx =  .17007470856;
Iyy =  .17159934710;
Izz =  .15858572070;
Ixy = -.00071033134*1;
Iyz = -.00240388659*1;
Ixz = -.00059844292*1;
% Ixx = 0.116331;
% Iyy = 0.108836;
% Izz = 0.114418;
% Ixy = -0.003204*0;
% Iyz = 0.000135*0;
% Ixz = 0.001778*0;

m_INERTIA = 1*[Ixx Ixy Ixz; Ixy Iyy Iyz; Ixz Iyz Izz]; %inertia matrix with cross terms, GIVEN BY ANSYS
side = 0.26; % length of side of satellite (m)

%% initial conditions
% wx0 = 2*pi/180;
% wy0 = 1*pi/180;    % wBIB at t = 0
% wz0 = -2*pi/180;
% 
% roll0   = 20*pi/180;
% pitch0  = 20*pi/180;    
% yaw0    = 20*pi/180;

wx0 = 12*pi/180;
wy0 = 12*pi/180;    % wBIB at t = 0
wz0 = 12*pi/180;

roll0   = 70*pi/180;
pitch0  = 140*pi/180;    
yaw0    = 50*pi/180;

q_BI0 = euler2qBI(roll0,pitch0,yaw0);

%% controller
s_MAG_B = 2.5e-5;
K_det = 4e4;
zeta = 1.15;
T = .125 * T_ORBIT;
delta = 0.015;
w = 1/ zeta/T;

Kdetumb = K_det*eye(3);

Kp = m_INERTIA * (w*w + 2*delta*zeta^2*w^2);
Kd = m_INERTIA * (2 + delta)* zeta * w;
Ki = m_INERTIA * delta * zeta * w^3;

% switching
tol_w = 4e-3; % tolerance for w_BOB
% no need to reduce it from 4e-3, below this satllite will take too long
% from detumbling to come to nominal.
tolw_n2d = 8e-3; 
% generally satellite rates in nominal are from 0 to 2e-3 so 8e-3 is good
% indication that rates are becoming too high.
%tolw_n2d = 10e-3;
%tolw_n2d = 6e-3;   can be taken without any problem but we want our sat to be in nomianal mode as much as possible.
tol_q4 = 0.85;
% check_time = 10000; % time between nominal and detumbling to check if detumbling mode is to be started again

%% SUN SENSORS
% sun sensor errors
s_x_SUNSENSOR = (.25)^2;     % SS error variance = 5%
Snum = 6;% sun sensor vectors in body frame (origin at body centre x : centre of
v_S1  = [1 0 0];
v_S2  = [-1 0 0];
v_S3  = [0 1 0];
v_S4  = [0 -1 0];
v_S5  = [0 0 1];
v_S6  = [0 0 -1];

% sun sensor ADC
s_SS_ADC_gain = 5; % amplified to 0-5 V
s_SS_ADC_res = 2^12 - 1; % 12 bit ADC
s_SS_MAX_ANGLE = 85; % angle in degree

%% MAGMETER
s_x_MAGMETER = (500e-9)^2;
s_x_MAGMETER_BIAS = 50e-9;

%% ACTUATOR
N = 40; % number fo turns
T_SIDE = 210 + (2*rand()-1)*0.1;
A = ((T_SIDE + .29)*1e-3)^2;
I_TORQUER = 3.6 / 7.31; % max current possible through torquer = V / R_torquer
I_MAX = 0.5; % max current given by power subsystem through torquer
s_PWM_RES = 1/(2^16-1); % resolution for PWM
v_x_MOUNTING_THETA_ZYX_BODY_TORQUER = [1; 1; 1]* pi/180; % mounting error in torquer; currently 1 degree each ?????
s_m_MAX = 0.95;

%% EXTERNAL TORQUES
Ca_Solar_Drag = 1.4; 
P_momentum_flux_from_the_sun = 4.4e-6; % momentum flux
v_COM_to_COP_b = [.2; 1.75; .2]*1e-2; %vector between centre of mass and centre of pressure
%aerodynamic drag
Cd = 2.2;
AMP = 4e-8;

%% QUEST

s_TAU_W = 60;
s_FRAME_SIZE = 2;
s_MAGMETER_WEIGHT = .9;

%% Power

Solar_Constant = 1353; %W/m^2
internal_resistance = 0.08; %ohms

Area_SP_S1 = 4*11*0.02025*0.04025; % Areas on side S1, in m^2 %leading
Area_SP_S2 = 4*11*0.02025*0.04025; % Areas on side S2, in m^2 %lagging
Area_SP_S3 = 0.0; % Areas on side S3, in m^2 %antisunside
Area_SP_S4 = 4*11*0.02025*0.04025; % Areas on side S4, in m^2 %sunside
Area_SP_S5 = 0.0; % Areas on side S5, in m^2 %nadir
Area_SP_S6 = 3*11*0.02025*0.04025; % Areas on side S6, in m^2 %zenith

efficiany_solar_cell = 0.16; % percentage
eclipse_time = T_ORBIT*0.4;  % approximated value, we don't need correct one.

%% END OF FILE %% 
