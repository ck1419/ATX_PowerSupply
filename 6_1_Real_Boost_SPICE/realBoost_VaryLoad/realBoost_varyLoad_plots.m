close all; clear all;

%% VaryVin
data = readmatrix('realBoost_varyLoad_results.xlsx','Sheet','Res','Range','A3:AD77885');

%%

vout_1_time = data(:,1);
vout_1_duty = data(:,2);
vout_1_data = data(:,3);
iin__1_data = data(:,4);
iout_1_data = data(:,5);

vout_2_time = data(:,1+5);
vout_2_duty = data(:,2+5);
vout_2_data = data(:,3+5);
iin__2_data = data(:,4+5);
iout_2_data = data(:,5+5);

vout_3_time = data(:,1+10);
vout_3_duty = data(:,2+10);
vout_3_data = data(:,3+10);
iin__3_data = data(:,4+10);
iout_3_data = data(:,5+10);

vout_4_time = data(:,1+15);
vout_4_duty = data(:,2+15);
vout_4_data = data(:,3+15);
iin__4_data = data(:,4+15);
iout_4_data = data(:,5+15);

vout_5_time = data(:,1+20);
vout_5_duty = data(:,2+20);
vout_5_data = data(:,3+20);
iin__5_data = data(:,4+20);
iout_5_data = data(:,5+20);

vout_6_time = data(:,1+25);
vout_6_duty = data(:,2+25);
vout_6_data = data(:,3+25);
iin__6_data = data(:,4+25);
iout_6_data = data(:,5+25);


%% Output voltages
figure(1);
clf;
plot(vout_1_time.*1000, vout_1_data, '-'); hold on;
plot(vout_2_time.*1000, vout_2_data, '-'); hold on;
plot(vout_3_time.*1000, vout_3_data, '-'); hold on;
plot(vout_4_time.*1000, vout_4_data, '-'); hold on;
plot(vout_5_time.*1000, vout_5_data, '-'); hold on;
plot(vout_6_time.*1000, vout_6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
ylim([50 600]);
xlim([0 6]);
ylabel('V_{out} (V)');
saveas(gcf,'realBoost_varyLoad_vout.jpeg')

%% Output load currents
figure(2); clf;
plot(vout_1_time.*1000, iout_1_data, '-'); hold on;
plot(vout_2_time.*1000, iout_2_data, '-'); hold on;
plot(vout_3_time.*1000, iout_3_data, '-'); hold on;
plot(vout_4_time.*1000, iout_4_data, '-'); hold on;
plot(vout_5_time.*1000, iout_5_data, '-'); hold on;
plot(vout_6_time.*1000, iout_6_data, '-'); hold on;
xlim([0 6]);
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
ylabel('I_{out} (A)');
saveas(gcf,'realBoost_varyLoad_iout.jpeg')

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
ylabel('I_{in} (A)');
xlim([0 6]);
saveas(gcf,'realBoost_varyLoad_iin.jpeg')

%% Input currents - Zoomed
figure(4); clf;
plot(vout_1_time.*1000, iin__1_data, '-'); hold on;
plot(vout_2_time.*1000, iin__2_data, '-'); hold on;
plot(vout_3_time.*1000, iin__3_data, '-'); hold on;
plot(vout_4_time.*1000, iin__4_data, '-'); hold on;
plot(vout_5_time.*1000, iin__5_data, '-'); hold on;
plot(vout_6_time.*1000, iin__6_data, '-'); hold on;
legend('100V', '150V', '200V', '250V','300V','350V')
xlabel('Time(ms)');
ylabel('I_{in} (A)');
xlim([5.8 6]);
saveas(gcf,'realBoost_varyLoad_iin_zoomed.jpeg')

%% Output current average not available from spice

iout_1_data_shortened = iout_1_data(50000:60000,1);
iout_2_data_shortened = iout_2_data(50000:60000,1);
iout_3_data_shortened = iout_3_data(50000:60000,1);
iout_4_data_shortened = iout_4_data(50000:60000,1);
iout_5_data_shortened = iout_5_data(50000:60000,1);
iout_6_data_shortened = iout_6_data(50000:60000,1);

avg_iout_1 = mean(iout_1_data_shortened);
avg_iout_2 = mean(iout_2_data_shortened);
avg_iout_3 = mean(iout_3_data_shortened);
avg_iout_4 = mean(iout_4_data_shortened);
avg_iout_5 = mean(iout_5_data_shortened);
avg_iout_6 = mean(iout_6_data_shortened);

avg_iout = [avg_iout_1 avg_iout_2 avg_iout_3 avg_iout_4 avg_iout_5 avg_iout_6];
