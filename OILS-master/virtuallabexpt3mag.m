%{
r=[-7062079;-514508;939];
v=[-68;1065;7427];
T1=0.1;
%}

function [B_O,B_I] = magfieldorbitconverter(r,v,T1)%r is the position vector %v is the velocity vector %T1 is  the time 
W_EARTH_ROT = 2*pi/86400;
stperut = 1.00273790935;
today = datenum('18-Oct-2010 10:30:0');% ** SGP, IGRF data are created for this date **
equinox = datenum('21-Mar-2010 12:0:0');% date of equinox
%r =[-7062079.00806833 ;-514508.728871005 ;939.271382227259];%ECI(1:3);   % position vector in ECI as it is a column vector actually they should be in ECEF
%v =[-68.7888019014781;1065.72557672168;7427.30756323931];%ECI(4:6);   % velocity vector in ECI  
LLA=zeros(4,1);
sime = datevec(today); % [ 2010    10    18    10    30    0]; % 
s_YEAR = decyear(sime);
TEI = eci2ecef(today,equinox, stperut,W_EARTH_ROT, T1);
    LLA = ecef2lla(r');% position vector transpose
    LAT = LLA(1);
    LONG = LLA(2);
    ALT = LLA(3)/1000;  % altitude in Km
    Dyear = s_YEAR + T1/86400/365;
B_NED = igrf(ALT, LAT, LONG, Dyear, 8);
B_ECEF = dcmecef2ned(LAT, LONG)'*B_NED';
B_I = TEI'*B_ECEF;%TEI'' gives the transpose mostly
oy = cross(v,r);    % orbit frame x...
oy = oy/sqrt(dot(oy,oy));

oz = -r/sqrt(dot(r,r));

ox = cross(oy,oz);
ox = ox/sqrt(dot(ox,ox));

TOI = [ox oy oz]';

B_O = TOI*B_I;

end