function rot_out = euler_to_rotmatrix(roll, pitch, yaw)
% Converts the euler angles into 3x3 rotation matrix rot_out
% Saurabh left this empty, so HH built it.

% HH, June 30, 2009
% Euler angle sequence: roll, pitch, yaw so that it is consistent with
% another script, quaternion_to_euler, used elsewhere

C_y = rotate_y(pitch);
C_x = rotate_x(roll);
C_z = rotate_z(yaw);

C_b_lvlh  = C_z *  C_y *  C_x;
rot_out   = C_b_lvlh;