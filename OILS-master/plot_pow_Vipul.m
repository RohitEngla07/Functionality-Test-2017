close all;
simNum = 5050;
T = T_ORBIT;
eclipse_color = [.5 .5 .5];
mcolor = [.85 .85 .85];
range = 1;
n = size(euler);
margin = ones(n(1),1)*10;
N = ones(length(N_save),1);
t2= 0:2:6*(length(t)-1);    % inserted by vipul 25_6_14

area(t/T, -2*range*light_est+range, -range, 'FaceColor', eclipse_color, 'EdgeColor', eclipse_color)
% area(t/T, light_est*range*2, 'FaceColor', eclipse_color, 'EdgeColor', eclipse_color)
hold on;

area(t2/T,-2*range*(1-flag_india)+range, -range, 'FaceColor', 'b', 'EdgeColor', 'b');
area(t2/T,-2*range*(1-flag_france)+range, -range, 'FaceColor', 'r', 'EdgeColor', 'r');

plot(t2/T , DOD);
plot(t/T, 2*range*N_save-range, 'm');
xlabel('No. of Orbits -->');
ylabel('DOD -->');
title('Altitude(700 km)');
axis([0,40,0,1]);

 % plot(t/T, euler(:,1), 'y', t/T, euler(:,2), 'm', t/T, euler(:,3), 'c','linewidth',1);

% legend('eclipse','downlink__india','downlink__france','roll','pitch','yaw')
% plot(t/T,  margin, 'Color', mcolor);
% plot(t/T, -margin, 'Color', mcolor);
% % str ={'wx0 = 5*pi/180;',
% % 'wy0 = 5*pi/180;',
% % 'wz0 = 5*pi/180;',
% % 'roll0   = 70*pi/180;',
% % 'pitch0  = 140*pi/180;',    
% % 'yaw0    = 50*pi/180;'}
% % text(25,150,str);
% % filename = sprintf('%04.0f_euler angles-polar.%s',simNum,ext);
% % saveas(gcf,filename)
% % hold off;