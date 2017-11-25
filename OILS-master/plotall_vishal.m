% This script plots all required graphs and saves them as figure files in
% current folder. variable 'simNum' must be defined in workspace. and be
% updated to reflect the number of the running simulation.

close all;
simNum = 5050;
T = T_ORBIT;
eclipse_color = [.95 .95 .95];
mcolor = [.85 .85 .85];
range = 200;
n = size(euler);
margin = ones(n(1),1)*10;
N = ones(length(N_save),1);
% Euler angles
area(t/T, -2*range*light+range, -range, 'FaceColor', eclipse_color, 'EdgeColor', eclipse_color)
hold on;
area(t2/T,-2*range*(1-flag_india)+range, -range, 'FaceColor', 'b', 'EdgeColor', 'b');
area(t2/T,-2*range*(1-flag_france)+range, -range, 'FaceColor', 'r', 'EdgeColor', 'r');
plot(t/T, euler(:,1), 'y', t/T, euler(:,2), 'm', t/T, euler(:,3), 'c','linewidth',1);
plot(t/T, 2*range*N_save-range, 'k');
legend('eclipse','downlink__india','downlink__france','roll','pitch','yaw')
plot(t/T,  margin, 'Color', mcolor);
plot(t/T, -margin, 'Color', mcolor);
xlabel('No. of Orbits -->');
ylabel('Euler Angles (deg) -->');
title('Attitude(700 km)');
str ={'wx0 = 5*pi/180;',
'wy0 = 5*pi/180;',
'wz0 = 5*pi/180;',
'roll0   = 70*pi/180;',
'pitch0  = 140*pi/180;',    
'yaw0    = 50*pi/180;'}
text(25,150,str);
filename = sprintf('%04.0f_euler angles-polar.%s',simNum,ext);
saveas(gcf,filename)
hold off;

% q_BO, est and real
subplot(4,1,1)
plot(t/T, abs(q_BO_est(:,1)), 'r', t/T, abs(q_BO_real(:,1)), 'g' );
title('q_B_O, real vs estimated');
ylabel('q_1');
subplot(4,1,2)
plot(t/T, abs(q_BO_est(:,2)), 'r', t/T, abs(q_BO_real(:,2)), 'g' );
ylabel('q_2');
subplot(4,1,3)
plot(t/T, abs(q_BO_est(:,3)), 'r', t/T, abs(q_BO_real(:,3)), 'g' );
ylabel('q_3');
subplot(4,1,4)
plot(t/T, abs(q_BO_est(:,4)), 'r', t/T, abs(q_BO_real(:,4)), 'g' );
ylabel('q_4');
filename = sprintf('%04.0f_q_est-polar.%s',simNum, ext);
saveas(gcf,filename)

% Current, Moment, Control Torque
subplot(2,1,1)
stairs(t/T, current);
title('Control')
ylabel('Current (A)')
% subplot(3,1,2)
% stairs(t/T, m_desired);
% ylabel('M-desired, Am^2 (max = 0.95)')
subplot(2,1,2)
stairs(t/T, u_control);
ylabel('\tau_c_o_n_t_r_o_l (Nm)')
filename = sprintf('%04.0f_control-polar.%s',simNum, ext);
saveas(gcf,filename)

% % Bi, Bo, Bb
% subplot(3,1,1)
% plot(t/T, v_Bi);
% title('Magnetic fiels in all frames');
% ylabel('B_I (T)')
% subplot(3,1,2)
% plot(t/T, v_Bo);
% ylabel('B_O (T)');
% subplot(3,1,3)
% plot(t/T, v_Bb_real);
% ylabel('B_B (T)');
% filename = sprintf('%04.0f_vB.%s',simNum, ext);
% saveas(gcf,filename)

% Bb vs B_m
subplot(3,1,1)
plot(t/T, v_Bb_real(:,1), 'g', t/T, v_Bb_m(:,1), 'b' );
title('B_B, measures vs estimated');
ylabel('B_1');
subplot(3,1,2)
plot(t/T, v_Bb_real(:,2), 'g', t/T, v_Bb_m(:,2), 'b' );
ylabel('B_2');
subplot(3,1,3)
plot(t/T, v_Bb_real(:,3), 'g', t/T, v_Bb_m(:,3), 'b' );
ylabel('B_3');
filename = sprintf('%04.0f_vBb_m-polar.%s',simNum, ext);
saveas(gcf,filename)

% w_BOB, w_BIB
range = 2*pi/180;
subplot(2,1,1)
area(t/T, -2*range*light+range, -range, 'FaceColor', eclipse_color, 'EdgeColor', eclipse_color)
hold on
plot(t/T, w_BOB_real);
title('\omega')
ylabel('\omega_B_O_B (rad/s)');
hold off
subplot(2,1,2)
area(t/T, -2*range*light+range, -range, 'FaceColor', eclipse_color, 'EdgeColor', eclipse_color)
hold on
plot(t/T, w_BIB_real);
ylabel('\omega_B_I_B (rad/s)');
hold off
filename = sprintf('%04.0f_w-polar.%s',simNum,ext);
saveas(gcf,filename)

% w_BOB compare
subplot(3,1,1)
plot(t/T, w_BOB_real(:,1), 'g', t/T, w_BOB_est(:,1), 'r' );
title('\omega_B_O_B comparison')
subplot(3,1,2)
plot(t/T, w_BOB_real(:,2), 'g', t/T, w_BOB_est(:,2), 'r' );
subplot(3,1,3)
plot(t/T, w_BOB_real(:,3), 'g', t/T, w_BOB_est(:,3), 'r' );
filename = sprintf('%04.0f_w_est.%s',simNum, ext);
saveas(gcf,filename)

% sunvector measured vs real
subplot(3,1,1)
plot(t/T, v_sun_real(:,1), 'g', t/T, v_sun_est(:,1), 'r' );
title('Sun Vector, measured vs real')
subplot(3,1,2)
plot(t/T, v_sun_real(:,2), 'g', t/T, v_sun_est(:,2), 'r' );
subplot(3,1,3)
plot(t/T, v_sun_real(:,3), 'g', t/T, v_sun_est(:,3), 'r' );
filename = sprintf('%04.0f_vSun_m.%s',simNum, ext);
saveas(gcf,filename)

% Si, So, Sb
subplot(3,1,1)
plot(t/T, v_Sun_i);
title('Sun Vector in all frames');
ylabel('S_I')
subplot(3,1,2)
plot(t/T, v_Sun_o_calc);
ylabel('S_O');
subplot(3,1,3)
plot(t/T, v_sun_real);
ylabel('S_B');
filename = sprintf('%04.0f_vSun.%s',simNum, ext);
saveas(gcf,filename)

filename = 'ic.txt';
fid = fopen(filename, 'a');
fprintf(fid, '\n%04.0f\t',simNum);
fprintf(fid, sprintf('% 5.2f ', roll0*180/pi))
fprintf(fid, sprintf('% 5.2f ', pitch0*180/pi))
fprintf(fid, sprintf('% 5.2f ', yaw0*180/pi))
fprintf(fid, sprintf('% 5.4f ', wx0*180/pi))
fprintf(fid, sprintf('% 5.4f ', wy0*180/pi))
fprintf(fid, sprintf('% 5.4f ', wz0*180/pi))
fclose(fid);

% close all;