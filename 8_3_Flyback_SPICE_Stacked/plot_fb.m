close all; 
clear;
clc;

%% Global controls

normal_start = 0;
normal_end = 5;
zoom_start = 35;
zoom_end = 50;


%% Read data

V = readmatrix('BasicFlyBack_AllRails_Stacked_Ctrl_load_varying Vout.txt');
time = V(:,1).*1000;
V5pos = V(:,2);
V12pos = V(:,3);
V5neg = V(:,4);
V12neg = V(:,5);
V33 = V(:,6);

P = readmatrix('BasicFlyBack_AllRails_Stacked_Ctrl_load_varying PWM.txt');
PWM = P(:,2);

I = readmatrix('BasicFlyBack_AllRails_Stacked_Ctrl_load_varying Ind currents.txt');
Lpri = I(:,2);
L5pos = I(:,3);
L12pos = I(:,4);
L5neg = I(:,5);
L12neg = I(:,6);
L33 = I(:,7);


%% Efficiency

E33 = mean(V33(1000000:end).*L33(1000000:end));
E5pos = mean(V5pos(1000000:end).*(L5pos(1000000:end)-L33(1000000:end)));
E12pos = mean(V12pos(1000000:end).*(L12pos(1000000:end)-L5pos(1000000:end)));
E5neg = mean(V5neg(1000000:end).*L5neg(1000000:end));
E12neg = mean(V12neg(1000000:end).*(L12neg(1000000:end)-L5neg(1000000:end)));
Etotal = E33 + E5pos + E12pos + E5neg + E12neg;

Epri = mean(400/sqrt(2)*Lpri(1000000:end));
Efficiency = Etotal/Epri;   

%% Plot voltages

figure(1)
hold on;
plot(time, V12pos);
plot(time, V5pos);
plot(time, V33);
plot(time, V5neg);
plot(time, V12neg);
xlim([normal_start normal_end]);
xlabel("Time (ms)")
ylabel("Voltage (V)")
legend("12V Rail", "5V Rail", "3.3V Rail", "-5V Rail", "12V Rail", 'Location', 'southeast')
saveas(gcf,'Stacked_varied_rail_voltage.jpeg')

figure(2)
plot(time, V12pos);
xlabel("Time (ms)")
ylabel("Voltage (V)")
xlim([zoom_start zoom_end]);
saveas(gcf,'Stacked_varied_12V_zoomed.jpeg')


%% Plot PWM

% figure(3)
% plot(time, PWM);
% xlabel("Time (ms)")
% ylabel("Voltage (V)")
% xlim([normal_start normal_end]);
% saveas(gcf,'Stacked_varied_rail_PWM.jpeg')
% 
% figure(4)
% plot(time, PWM);
% xlabel("Time (ms)")
% ylabel("Voltage (V)")
% xlim([19.8 20]);
% saveas(gcf,'Stacked_varied_rail_PWM_zoom.jpeg')


%% Plot currents

figure(5)
hold on;
plot(time, L5pos);
plot(time, L33);
plot(time, L5neg);
xlim([normal_start normal_end]);
xlabel("Time (ms)")
ylabel("Current (A)")
legend("5V Inductor", "3.3V Inductor", "-5V Inductor")
saveas(gcf,'Stacked_varied_rail_out_ind1.jpeg')

figure(6)
hold on;
plot(time, L12pos);
plot(time, L12neg);
xlim([normal_start normal_end]);
xlabel("Time (ms)")
ylabel("Current (A)")
ylim([-150 50]);
legend("12V Inductor", "-12V Inductor")
saveas(gcf,'Stacked_varied_rail_out_ind2.jpeg')

figure(7)
plot(time, Lpri);
xlim([normal_start normal_end]);
xlabel("Time (ms)")
ylabel("Current (A)")
saveas(gcf,'Stacked_varied_rail_pri_ind.jpeg')

figure(8)
plot(time, Lpri);
xlim([19.5 20]);
xlabel("Time (ms)")
ylabel("Current (A)")
saveas(gcf,'Stacked_varied_rail_pri_ind_zoom.jpeg')