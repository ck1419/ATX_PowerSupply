close all; clear all;

%% VaryVin
data = readmatrix('realBoost_varyVin_results.xlsx','Sheet','Res','Range','A3:AP180000');

%%

vout_1_time = data(:,1);
vout_1_data = data(:,4);
iin__1_data = data(:,6);
iout_1_data = data(:,7);

vout_2_time = data(:,1+7);
vout_2_data = data(:,4+7);
iin__2_data = data(:,6+7);
iout_2_data = data(:,7+7);

vout_3_time = data(:,1+14);
vout_3_data = data(:,4+14);
iin__3_data = data(:,6+14);
iout_3_data = data(:,7+14);

vout_4_time = data(:,1+21);
vout_4_data = data(:,4+21);
iin__4_data = data(:,6+21);
iout_4_data = data(:,7+21);

vout_5_time = data(:,1+28);
vout_5_data = data(:,4+28);
iin__5_data = data(:,6+28);
iout_5_data = data(:,7+28);

vout_6_time = data(:,1+35);
vout_6_data = data(:,4+35);
iin__6_data = data(:,6+35);
iout_6_data = data(:,7+35);


%% Output voltages
figure(1);
plot(vout_1_time.*1000, vout_1_data, '-'); hold on;
plot(vout_2_time.*1000, vout_2_data, '-'); hold on;
plot(vout_3_time.*1000, vout_3_data, '-'); hold on;
plot(vout_4_time.*1000, vout_4_data, '-'); hold on;
plot(vout_5_time.*1000, vout_5_data, '-'); hold on;
plot(vout_6_time.*1000, vout_6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
xlim([0 4]);
ylim([50 550]);
ylabel('V_{out} (V)');
saveas(gcf,'realBoost_varyVin_vout.jpeg')

%% Output currents
figure(2); clf;
plot(vout_1_time.*1000, iout_1_data, '-'); hold on;
plot(vout_2_time.*1000, iout_2_data, '-'); hold on;
plot(vout_3_time.*1000, iout_3_data, '-'); hold on;
plot(vout_4_time.*1000, iout_4_data, '-'); hold on;
plot(vout_5_time.*1000, iout_5_data, '-'); hold on;
plot(vout_6_time.*1000, iout_6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
xlim([0 4]);
ylabel('I_{out} (A)');
saveas(gcf,'realBoost_iout.jpeg')

%% Output currents zoomed
figure(2); clf;
plot(vout_1_time.*1000, iout_1_data, '-'); hold on;
plot(vout_2_time.*1000, iout_2_data, '-'); hold on;
plot(vout_3_time.*1000, iout_3_data, '-'); hold on;
plot(vout_4_time.*1000, iout_4_data, '-'); hold on;
plot(vout_5_time.*1000, iout_5_data, '-'); hold on;
plot(vout_6_time.*1000, iout_6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
xlim([9.9 10]);
ylim([1.6 1.7]);
ylabel('I_{out} (A)');
saveas(gcf,'realBoost_iout_zoomed.jpeg')

%% Input currents
figure(3); clf;
plot(vout_1_time.*1000, iin__1_data, '-'); hold on;
plot(vout_2_time.*1000, iin__2_data, '-'); hold on;
plot(vout_3_time.*1000, iin__3_data, '-'); hold on;
plot(vout_4_time.*1000, iin__4_data, '-'); hold on;
plot(vout_5_time.*1000, iin__5_data, '-'); hold on;
plot(vout_6_time.*1000, iin__6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
xlim([15.5 16]);
ylabel('I_{in} (A)');
saveas(gcf,'realBoost_iin.jpeg')

%% Output current average not available from spice

iout_1_data_shortened = iout_1_data(10000:11000,1);
iout_2_data_shortened = iout_2_data(9000:10000,1);

avg_iout_1 = mean(iout_1_data_shortened);
avg_iout_2 = mean(iout_2_data_shortened);
avg_iout_3 = mean(iout_3_data, [120000:1300000, 1]);
avg_iout_4 = mean(iout_4_data, [120000:1300000, 1]);
avg_iout_5 = mean(iout_5_data, [120000:1300000, 1]);
avg_iout_6 = mean(iout_6_data, [120000:1300000, 1]);

%%
avg_iout = [avg_iout_1 avg_iout_2 avg_iout_3 avg_iout_4 avg_iout_5 avg_iout_6];
