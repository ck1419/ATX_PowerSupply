close all; clear all;

%% VaryVin
data = xlsread('simulation_timeresults_varyVin.xlsx','A2:L43025');

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


figure(1);
plot(vin1_time.*1000, vin1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin2_time.*1000, vin2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin3_time.*1000, vin3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin4_time.*1000, vin4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin5_time.*1000, vin5_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin6_time.*1000, vin6_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('100V','150V','200V','250V','300V','350V')
xlabel('Time(ms)');
ylabel('V_{out}');
xlim([0 2.5]);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);

filename = ['ideal_boost_varyvin_startup.jpg'];
saveas(gcf,filename)

%% VaryLoad

data = xlsread('simulation_timeresults_varyLoad.xlsx','A2:L41735');

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

figure(2);
plot(vin1_time.*1000, vin1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin2_time.*1000, vin2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin3_time.*1000, vin3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin4_time.*1000, vin4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin5_time.*1000, vin5_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(vin6_time.*1000, vin6_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('100%','90%','80%','70%','60%','50%')
xlabel('Time(ms)');
ylabel('V_{out}');
xlim([0 4]);
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);

filename = ['ideal_boost_varyLoad_startup.jpg'];
saveas(gcf,filename)
