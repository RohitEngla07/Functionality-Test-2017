function rot_out= rotate_y(angle)
%Rotation matrix after rotating about the y axis
%By Saurabh Chatterjee

% June 20, 2009:
% corrected by H. Hablani
% Earlier code:
% function rot_out= rotate_z(angle)
% rot_out = [cos(angle)   0       sin(angle) ;...
%            0           1      0;...
%           -sin(angle)  0       cos(angle)];


rot_out = [cos(angle)   0       -sin(angle);...
            0           1        0;...
           sin(angle)   0        cos(angle)];