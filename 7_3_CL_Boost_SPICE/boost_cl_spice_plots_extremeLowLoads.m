close all; clear all;

%% VaryVin
data = xlsread('CL_Boost_Spice_ExtremeLowLoads.xlsx','A3:T440348');
%%

vout_1_time = data(:,1);
vout_1_data = data(:,2);
iL_1_data = data(:,4);
vout_2_time  = data(:,6);
vout_2_data = data(:,7);
iL_2_data = data(:,9);
vout_3_time  = data(:,11);
vout_3_data = data(:,12);
iL_3_data = data(:,14);
vout_4_time  = data(:,16);
vout_4_data = data(:,17);
iL_4_data = data(:,19);


%% Output voltages
figure(1);
plot(vout_1_time.*1000, vout_1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_2_time.*1000, vout_2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_3_time.*1000, vout_3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_4_time.*1000, vout_4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('100V, 1% Load', '100V, 10% Load', '350V, 1% Load', '350V, 10% Load')
xlabel('Time(ms)');
xlim([0 20]);
ylabel('V_{out} (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
saveas(gcf,'complete_boost_compare_extremeLowLoads.jpeg')

%% Inductor currents
figure(2);
plot(vout_1_time.*1000, iL_1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_2_time.*1000, iL_2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_3_time.*1000, iL_3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_4_time.*1000, iL_4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('100V, 1% Load', '100V, 10% Load', '350V, 1% Load', '350V, 10% Load')
xlabel('Time(ms)');
xlim([0 20]);
ylim([-1 3]);
ylabel('I_{L} (A)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
saveas(gcf,'complete_boost_compare_extremeLowLoads_indcurrents.jpeg')