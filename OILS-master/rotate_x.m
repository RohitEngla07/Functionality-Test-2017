function rot_out= rotate_x(angle)
%Rotation matrix after rotating about the x axis
%By Saurabh Chatterjee

rot_out = [  1         0           0;...
             0         cos(angle)  sin(angle);...
             0        -sin(angle)  cos(angle)];