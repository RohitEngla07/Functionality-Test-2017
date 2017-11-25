%% USe this file to do earth related calculations for given date. Orbit, B
% data is stored in corresponding files.

% Following files are required:
% 
% getOrbitData.m
% sgp.m
% eci2ecef.m
% igrf.m
% SGP_estimator.mdl *
% sh2015.mat

%% Constants
tic
s_SIM_STEP_SIZE = 0.1;
s_FRAME_SIZE = 2;

% TIME
today = datenum('18-Oct-2015 10:30:0'); % ** SGP, IGRF data are created for this date **
equinox = datenum('20-Mar-2015 22:45:0'); % date of equinox
TLE_epoch = datenum('18-Oct-2015 10:30:0'); % time when TLE orb elements were true = constant
julianStart = datenum('1-Jan-2000 12:0:0'); %date of start of Julian Epoch
stperut = 1.00273790935;    % siderial time = stperut * universal time

sime = datevec(today); % [ 2010    10    18    10    30    0]; % 
s_YEAR = decyear(sime);     % decimal year i.e. 2010....
s_YEAR_ONLY = sime(1); % current decimal year i.e 2010

s_DOY = doy(sime(3),sime(2),sime(3)); % day of year 
s_SEC = sime(4)*3600 + sime(5)*60 + sime(6); % second of the day (0 to 86400)

% SGP (Orbit parameters / ICs)
W_EARTH_ROT = 2*pi/86400;   % rotation angular velocity of earth, SI
R_e = 6378164 + 600000;    % Earth radius + Height of sat
mu=6.673e-11*5.9742e24;    % G*M_earth, SI ??????
s_W_SAT =sqrt(mu/R_e^3); % angular velocity of revolution of satellite in rad/sec
T_ORBIT = 2*pi/s_W_SAT;  % orbital period

meanMo = sqrt(mu/R_e^3)*86400/2/pi; % w_SAT in rev/day
orbEcc = 0;     % 0 for circular orbit
orbInc = 97.7925;%98.1873; % constant
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


%% calculate true SGP4 data

getOrbitData;
dT = 0:0.1:240000;
[X, V] = sgp(modTLE,dT/60 + (today-TLE_epoch)*86400/60);
SGP_120k = [dT; X'; V'];
% plot(dT, X)
save SGP_120k.mat SGP_120k

%% Run sim to calculate Estimated SGP vector

sout = sim('SGP_estimator');    % saves SGP_est_120k.mat file which contains measures->propagated Orbit data, at 2 sec step


%% calculate True Magnetic field (PAINFUL!! Takes ONE HOUR)

T = SGP_120k(1,:);
x = SGP_120k(2:4,:);
N = length(x);

Bned_120k = zeros(4,N);
Bi_120k = zeros(4,N);
LLA_120k = zeros(4,N);

for i=1:N
    TEI = eci2ecef(today,equinox, stperut,W_EARTH_ROT, T(i));
    X_ECEF = (TEI*x(:,i))';
    LLA = ecef2lla(X_ECEF);
    LAT = LLA(1);
    LONG = LLA(2);
    ALT = LLA(3)/1000;  % altitude in Km

    Dyear = s_YEAR + T(i)/86400/365;

    B_NED = igrf(ALT, LAT, LONG, Dyear, 13);
    
    B_ECEF = dcmecef2ned(LAT, LONG)'*B_NED';
    
    B_I = TEI'*B_ECEF;

    Bned_120k(1,i) = T(i);
    Bi_120k(1,i) = T(i);
    LLA_120k(1,i) = T(i);

    Bned_120k(2:4,i) = B_NED;
    Bi_120k(2:4,i) = B_I;
    LLA_120k(2:4,i) = [LAT; LONG; ALT];
    
    if mod(i,1000) == 0 
        fprintf('done %i\n',i/10)
    end

end

save Bi_120k.mat Bi_120k
save Bned_120k.mat Bned_120k
save LLA_120k.mat LLA_120k


%% Calculate Estimated magnetic field
load SGP_est_120k;
T = SGP_est_120k(1,:);
x = SGP_est_120k(2:4,:);
N = length(x);

Bned8_est_120k = zeros(4,N);
Bi8_est_120k = zeros(4,N);
LLA_est_120k = zeros(4,N);

for i=1:N
    TEI = eci2ecef(today,equinox, stperut,W_EARTH_ROT, T(i));
    X_ECEF = (TEI*x(:,i))';
    LLA = ecef2lla(X_ECEF);
    LAT = LLA(1);
    LONG = LLA(2);
    ALT = LLA(3)/1000;  % altitude in Km

    Dyear = s_YEAR + T(i)/86400/365;

    B_NED = igrf(ALT, LAT, LONG, Dyear, 8);
    
    B_ECEF = dcmecef2ned(LAT, LONG)'*B_NED';
    
    B_I = TEI'*B_ECEF;

    Bned8_est_120k(1,i) = T(i);
    Bi8_est_120k(1,i) = T(i);
    LLA_est_120k(1,i) = T(i);

    Bned8_est_120k(2:4,i) = B_NED;
    Bi8_est_120k(2:4,i) = B_I;
    LLA_est_120k(2:4,i) = [LAT; LONG; ALT];
    
    if mod(i,1000) == 0 
        fprintf('done %i\n',i/10)
    end

end

save Bi8_est_120k.mat Bi8_est_120k
save Bned8_est_120k.mat Bned8_est_120k
save LLA_est_120k.mat LLA_est_120k
toc

%% PRECALCS DONE
