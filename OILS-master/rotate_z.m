function rot_out= rotate_z(angle)
%Rotation matrix after rotating about the z axis
%By Saurabh Chatterjee

rot_out = [ cos(angle) sin(angle) 0;...
           -sin(angle) cos(angle) 0;...
            0               0            1];