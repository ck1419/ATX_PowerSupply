close all; clear all;

data = xlsread('simulation_timeresults.xlsx','A2:L43025');

%%
vin1_time = data(:,1);
vin1_data = data(:,2);
vin2_time = data(:,3);
vin2_data = data(:,4);
vin3_time = data(:,5);
vin3_data = data(:,6);
vin4_time = data(:,7);
vin4_data = data(:,8);
vin5_time = data(:,9);
vin5_data = data(:,10);
vin6_time = data(:,11);
vin6_data = data(:,12);

%% 
figure(1);
plot(vin1_time, vin1_data, 'x-', 'LineWidth',2); hold on;
plot(vin2_time, vin2_data, 'x-', 'LineWidth',2); hold on;
plot(vin3_time, vin3_data, 'x-', 'LineWidth',2); hold on;
plot(vin4_time, vin4_data, 'x-', 'LineWidth',2); hold on;
plot(vin5_time, vin5_data, 'x-', 'LineWidth',2); hold on;
plot(vin6_time, vin6_data, 'x-', 'LineWidth',2); hold on;
legend('100V','150V','200V','250V','300V','350V')
xlabel('Time(s)');
ylabel('V_{out}');
xlim([0 0.0025]);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
