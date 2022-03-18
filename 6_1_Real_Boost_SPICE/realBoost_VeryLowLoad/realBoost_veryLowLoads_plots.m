close all; clear all;

%% VaryVin
data = readmatrix('realBoost_veryLowLoad_results.xlsx','Sheet','Res','Range','A3:Y286533');

%%

vout_1_time = data(:,1);
vout_1_data = data(:,3);
iin__1_data = data(:,4);
iout_1_data = data(:,5);

vout_2_time = data(:,1+5);
vout_2_data = data(:,3+5);
iin__2_data = data(:,4+5);
iout_2_data = data(:,5+5);

vout_3_time = data(:,1+10);
vout_3_data = data(:,3+10);
iin__3_data = data(:,4+10);
iout_3_data = data(:,5+10);

vout_4_time = data(:,1+15);
vout_4_data = data(:,3+15);
iin__4_data = data(:,4+15);
iout_4_data = data(:,5+15);

vout_5_time = data(:,1+20);
vout_5_data = data(:,3+20);
iin__5_data = data(:,4+20);
iout_5_data = data(:,5+20);


%% Output voltages
figure(1); clf;
plot(vout_1_time.*1000, vout_1_data, '-'); hold on;
plot(vout_2_time.*1000, vout_2_data, '-'); hold on;
plot(vout_3_time.*1000, vout_3_data, '-'); hold on;
plot(vout_4_time.*1000, vout_4_data, '-'); hold on;
plot(vout_5_time.*1000, vout_5_data, '-'); hold on;
legend('10%','5%','2%','1%','0.1%','Location','Southeast')
xlabel('Time(ms)');
xlim([0 12]);
ylim([50 650]);
ylabel('V_{out} (V)');
saveas(gcf,'realBoost_veryLowLoad_vout.jpeg')

%% Output currents
figure(2); clf;
plot(vout_1_time.*1000, iout_1_data, '-'); hold on;
plot(vout_2_time.*1000, iout_2_data, '-'); hold on;
plot(vout_3_time.*1000, iout_3_data, '-'); hold on;
plot(vout_4_time.*1000, iout_4_data, '-'); hold on;
plot(vout_5_time.*1000, iout_5_data, '-'); hold on;
legend('10%','5%','2%','1%','0.1%')
xlabel('Time(ms)');
xlim([0 12]);
ylabel('I_{out} (A)');
saveas(gcf,'realBoost_veryLowLoad_iout.jpeg')

%% Input currents
figure(4); clf;
plot(vout_1_time.*1000, iin__1_data, '-'); hold on;
plot(vout_2_time.*1000, iin__2_data, '-'); hold on;
plot(vout_3_time.*1000, iin__3_data, '-'); hold on;
plot(vout_4_time.*1000, iin__4_data, '-'); hold on;
plot(vout_5_time.*1000, iin__5_data, '-'); hold on;
legend('10%','5%','2%','1%','0.1%')
xlabel('Time(ms)');
ylabel('I_{in} (A)');
saveas(gcf,'realBoost_veryLowLoad_iin.jpeg')

%% Input currents zoomed
figure(4); clf;
plot(vout_1_time.*1000, iin__1_data, '-'); hold on;
plot(vout_2_time.*1000, iin__2_data, '-'); hold on;
plot(vout_3_time.*1000, iin__3_data, '-'); hold on;
plot(vout_4_time.*1000, iin__4_data, '-'); hold on;
plot(vout_5_time.*1000, iin__5_data, '-'); hold on;
legend('10%','5%','2%','1%','0.1%')
xlabel('Time(ms)');
ylabel('I_{in} (A)');
xlim([14 14.1]);
ylim([-0.2 1]);
saveas(gcf,'realBoost_veryLowLoad_iin_zoomed.jpeg')
