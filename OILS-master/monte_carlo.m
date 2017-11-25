% code for monte carlo simulation
%determine the number of cases to be run

N_case = 500;

%Create the test matrix for the euler angles with which to test the control
%law

test_eulers = rand(N_case , 3);

test_eulers = 180*test_eulers;

%start the test loop
%initialising the categories
a = 1;
j = 1;
k = 1;
l = 1;
m = 1;
n = 1;
cat1(1,:) = [0 0 0];
cat2(1,:) = [0 0 0];
cat3(1,:) = [0 0 0];
cat4(1,:) = [0 0 0];
cat5(1,:) = [0 0 0];
cat6(1,:) = [0 0 0];
for i = 1:N_case

%run the constants file to initiate the simulation

run('E:\adcs_v15_BackUp\constants_v15_Pow.m');

%replace the initial euler angles with the ones given by the test matrix

roll0   = test_eulers(i , 1)*pi/180;
pitch0  = test_eulers(i , 2)*pi/180;    
yaw0    = test_eulers(i , 3)*pi/180;

q_BI0 = euler2qBI(roll0,pitch0,yaw0);

% run the nominal mode simulation and save the results
simout = sim('adcs_v15_integral_Power_nom' , 'SimulationMode' , 'rapid');
t = simout.find('t');
euler = simout.find('euler');
t1 = 120000 - 18000;
t_check = [t1 : 1 : 120000];
euler_check = interp1(t , euler , t_check);
euler_max = max(abs(euler_check));
euler_max = max(abs(euler_max));
save_euler(i) = euler_max;

%4 categories within 3 (blue) , within 5(magenta) , within 7(green) and
%within 10(yellow) , within 20(red) , beyond 20(black)



if (euler_max <= 3)
    cat1(a , :) = [roll0 pitch0 yaw0]*180/pi;
    a = a+1;
end

if (euler_max >=3 && euler_max <=5)
    cat2(j , :) = [roll0 pitch0 yaw0]*180/pi;
    j = j+1;
end

if (euler_max >=5 && euler_max <=7)
    cat3(k , :) = [roll0 pitch0 yaw0]*180/pi;
    k = k+1;
end

if (euler_max >=7 && euler_max <=10)
    cat4(l , :) = [roll0 pitch0 yaw0]*180/pi;
    l = l+1;
end

if (euler_max >=10 && euler_max <=20)
    cat5(m , :) = [roll0 pitch0 yaw0]*180/pi;
    T = 6000;
    eclipse_color = [.95 .95 .95];
    mcolor = [.85 .85 .85];
    range = 200;
    n = size(euler);
    margin = ones(n(1),1)*10;
    hold on;
    plot(t/T,  margin, 'Color', mcolor);
    plot(t/T, -margin, 'Color', mcolor);
    plot(t/T, euler(:,1), 'y', t/T, euler(:,2), 'm', t/T, euler(:,3), 'c');
    xlabel('No. of Orbits -->');
    ylabel('Euler Angles (deg) -->');
    title('Attitude');
    filename = sprintf('%i_attitude_high.%s',m,'fig');
    saveas(gcf,filename)
hold off;
    m = m+1;
end

if (euler_max >=20)
    cat6(n , :) = [roll0 pitch0 yaw0]*180/pi;
    T = 6000;
    eclipse_color = [.95 .95 .95];
    mcolor = [.85 .85 .85];
    range = 200;
    n = size(euler);
    margin = ones(n(1),1)*10;
    hold on;
    plot(t/T,  margin, 'Color', mcolor);
    plot(t/T, -margin, 'Color', mcolor);
    plot(t/T, euler(:,1), 'y', t/T, euler(:,2), 'm', t/T, euler(:,3), 'c');
    xlabel('No. of Orbits -->');
    ylabel('Euler Angles (deg) -->');
    title('Attitude');
    filename = sprintf('%i_attitude_v_high.%s',n,'fig');
    saveas(gcf,filename)
hold off;
    n = n+1;
end
fprintf('%s %i\n' , 'done' , i);
end

%All simulation cases have been run and must be plotted appropriately

hold on

plot3(cat1(:,1) , cat1(:,2) , cat1(:,3) , '*' , 'Color' , 'yellow');
plot3(cat2(:,1) , cat2(:,2) , cat2(:,3) , '*' , 'Color' , 'green');
plot3(cat3(:,1) , cat3(:,2) , cat3(:,3) , '*' , 'Color' , 'blue');

plot3(cat4(:,1) , cat4(:,2) , cat4(:,3) , '*' , 'Color' , 'magenta');
plot3(cat5(:,1) , cat5(:,2) , cat5(:,3) , '*' , 'Color' , 'red');
plot3(cat6(:,1) , cat6(:,2) , cat6(:,3) , '*' , 'Color' , 'black');

filename = sprintf('%s %i %s' , 'monte_carlo_results_' , N_case , ' cases.fig');
saveas(gcf , filename)
save monte_carlo_result.mat

