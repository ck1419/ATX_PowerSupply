close all; clear all;

%% VaryVin
data = xlsread('CL_Boost_SPICE_Results.xlsx','A3:H364104');
%%

vout_1_time = data(:,1);
vout_1_data = data(:,2);
vout_2_time  = data(:,3);
vout_2_data = data(:,4);
vout_3_time  = data(:,5);
vout_3_data = data(:,6);
vout_4_time  = data(:,7);
vout_4_data = data(:,8);


%% Output voltages
figure(1);
plot(vout_1_time.*1000, vout_1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_2_time.*1000, vout_2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_3_time.*1000, vout_3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vout_4_time.*1000, vout_4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('100V, 50% Load', '100V, 100% Load', '350V, 50% Load', '350V, 100% Load')
xlabel('Time(ms)');
xlim([0 10]);
ylabel('V_{out} (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
saveas(gcf,'complete_boost_compare.jpeg')