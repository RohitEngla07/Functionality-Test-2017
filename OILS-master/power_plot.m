simnum = 100;

figure(1);
T_orb = 5800.84398440392;
subplot(2,1,1);
plot(t2/5800.84398440392 , state_of_charge , t2/5800.84398440392 , downlink_flag);
xlabel('Orbits');
grid on
ylabel('State of Charge (fraction)');
title('State of charge');
subplot(2,1,2);

plot(t/5800.84398440392 , N_save);
axis([0 20 0 2]);
xlabel('orbits');
title('control mode');
grid on;

filename = sprintf('%s %i %s' , 'state_of_charge_' , simnum , '_.jpg');
saveas(gcf , filename);
subplot(1,1,1);
plot(t2/5800.84398440392 , V_bat);
xlabel('orbits');
ylabel('Cell Voltage (V)');
grid on;

title ('cell Voltage');
filename = sprintf('%s %i %s' , 'cell_volt_' , simnum , '_.jpg');
saveas(gcf , filename);

subplot(2,1,1);
plot(t2/5800.84398440392 , Excess_power);
xlabel('orbits');
ylabel('Excess Power (W)');
grid on;

title('Excess power available');
subplot(2,1,2);
plot(t2/5800.84398440392 , generated_power);
xlabel('orbits');
ylabel('Generated power (W)');
grid on;

title('Power Generated By Solar Panels');
filename = sprintf('%s %i %s' , 'power_' , simnum , '_.jpg');
saveas(gcf , filename);