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
    
%%
clc; clear; close all;

%% Configuration Parameters
s_SIM_STEP_SIZE = 0.1;  % integration step size
Ts_display = 6;     % sample time for data logging
ext = 'jpg';

%% TIME
today = datenum('18-Oct-2010 10:30:0'); % ** SGP, IGRF data have been created for this date **
equinox = datenum('21-Mar-2010 12:0:0'); % date of equinox

%% SGP (Orbit parameters / ICs)
R_e = 6378164 + 817000;    % Earth radius + Height of sat
mu=6.673e-11*5.9742e24;    % G*M_earth, SI ??????
s_W_SAT =sqrt(mu/R_e^3); % angular velocity of revolution of satellite in rad/sec
T_ORBIT = 2*pi/s_W_SAT;  % orbital period

%% Inertia
% GG stability condition: Iyy > Ixx > Izz
Ixx =  .17007470856;
Iyy =  .17159934710;
Izz =  .15858572070;
Ixy = -.00071033134;
Iyz = -.00240388659;
Ixz = -.00059844292;
% Ixx = 0.116331;
% Iyy = 0.108836;
% Izz = 0.114418;
% Ixy = -0.003204*0;
% Iyz = 0.000135*0;
% Ixz = 0.001778*0;

m_INERTIA = [Ixx Ixy Ixz; Ixy Iyy Iyz; Ixz Iyz Izz]; % ?????? inertia matrix with cross terms, GIVEN BY ANSYS
side = 0.26; % length of side of satellite

%% initial conditions
% wx0 = 2*pi/180;
% wy0 = 1*pi/180;    % wBIB at t = 0
% wz0 = -2*pi/180;
% 
% roll0   = 20*pi/180;
% pitch0  = -32*pi/180;    
% yaw0    = 88*pi/180;

wx0 = 1*pi/180;
wy0 = 0*pi/180;    % wBIB at t = 0
wz0 = -.5*pi/180;

roll0   = 10*pi/180;
pitch0  = -32*pi/180;    
yaw0    = 88*pi/180;

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
tol_w = 4e-3; % tolerance for w_BOB (reduce?)
tolw_n2d = 10e-3;
tol_q4 = 0.85;
check_time = 10000; % time between nominal and detumbling to check if detumbling mode is to be started again

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
N = 40;
T_SIDE = 210 + (2*rand()-1)*0.1;
A = ((T_SIDE + .29)*1e-3)^2;
I_TORQUER = 3.6 / 7.31; % max current possible through torquer = V / R_torquer
I_MAX = 0.5; % max current given by power subsystem through torquer
s_PWM_RES = 1/(2^16-1); % resolution for PWM
v_x_MOUNTING_THETA_ZYX_BODY_TORQUER = [1; 1; 1]* pi/180; % mounting error in torquer; currently 1 degree each ?????
s_m_MAX = 0.95;

%% EXTERNAL TORQUES
Ca_Solar_Drag = 1.4; %what is this???
P_momentum_flux_from_the_sun = 4.4e-6; % momentum flux
v_COM_to_COP_b = [.2; 1.75; .2]*1e-2; %vector between centre of mass and centre of pressure??????
%aerodynamic drag
Cd = 2.2;

%% QUEST

s_TAU_W = 60;
s_FRAME_SIZE = 2;
s_MAGMETER_WEIGHT = .9;

%% Correcting errors
% from precals

% TIME
TLE_epoch = datenum('18-Oct-2010 10:30:0'); % time when TLE orb elements were true = constant
julianStart = datenum('1-Jan-2000 12:0:0'); %date of start of Julian Epoch
stperut = 1.00273790935;    % siderial time = stperut * universal time

sime = datevec(today); % [ 2010    10    18    10    30    0]; % 
s_YEAR = sime(1) + (sime(2)*30 - 30 + sime(3))/365;     % decimal year i.e. 2010....
s_YEAR_ONLY = sime(1); % current decimal year i.e 2010
s_DOY = sime(2)*30 - 30 + sime(3); % day of year 
s_SEC = sime(4)*3600 + sime(5)*60 + sime(6); % second of the day (0 to 86400)

% SGP (Orbit parameters / ICs)
W_EARTH_ROT = 2*pi/86400;   % rotation angular velocity of earth, SI
R_e = 6378164 + 817000;    % Earth radius + Height of sat
mu=6.673e-11*5.9742e24;    % G*M_earth, SI ??????
s_W_SAT =sqrt(mu/R_e^3); % angular velocity of revolution of satellite in rad/sec
T_ORBIT = 2*pi/s_W_SAT;  % orbital period

meanMo = sqrt(mu/R_e^3)*86400/2/pi; % w_SAT in rev/day
orbEcc = 0;     % 0 for circular orbit
orbInc = 98.68; % constant
argPer = 0;     % 0 for circular orbit
meanAno = - argPer;%88.4025;
rghtAsc = 184.168;
SGPdragp1 = -7.86e-006;
SGPdragp2 = 0;
SGP4dragp = -3.5889e-005;
EpYear = mod(sime(1),100);
EpJD = s_DOY;
EpTime = s_SEC/86400;
revNo = 1;

% GPS
s_x_GPS_X = (10000/2)^2; % specified error in position mm
s_x_GPS_V = (120/2)^2; % specified error in velocity mm/s
t_reset = 600; % time when orbit propagator should reset to GPS values

% from light_calc
% constants
s_Rearth = 6378164;
s_AU = 159597870610;
s_Rsun = 695500000;
solar_constant = 1366;  % ??????

err_SGP = 0;

load sh2010
%% END OF FILE %% 
