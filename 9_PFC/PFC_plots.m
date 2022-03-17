close all; clear all;

%% Data
M = readmatrix('Real PFC - fast results.txt');

time_step = M(:,1);
vout_v = M(:,2);
acin_i  = M(:,3);
l1_i = M(:,4);
r5_i  = M(:,5);
r6_i = M(:,6);

%% Plot values
figure(1);
plot(time_step.*1000, vout_v);
xlabel('Time(ms)');
ylabel('V_{out} (V)');
saveas(gcf,'PFC_Vout.jpeg')

figure(2);
plot(time_step.*1000, acin_i);
xlabel('Time(ms)');
ylabel('AC_{in} (A)');
saveas(gcf,'PFC_ACin.jpeg')

figure(3);
plot(time_step.*1000, r5_i+r6_i);
xlabel('Time(ms)');
ylabel('I_{out} (A)');
saveas(gcf,'PFC_Iout.jpeg')

figure(4)
plot(time_step(2657489/3:1:2657489).*1000, vout_v(2657489/3:1:2657489));
xlim([800 1000]);
xlabel('Time(ms)');
ylabel('V_{out} (V)');
saveas(gcf,'PFC_Vout_zoom.jpeg')


%% FFT Data

FFT = readcell('Real PFC - fast FFT.txt');
frequency = FFT(:,1);
frequency = cell2mat(frequency(2:end));

tuple = FFT(:,2);
tuple = split(tuple(2:end), "d");
tuple = tuple(:,1);
tuple = split(tuple, "(");


decibels = tuple(:,2);
decibels = split(decibels, "e");
decibels = cellfun(@str2num, decibels);
power_mat = 10.^decibels(:,2);
decibels = decibels(:,1) .* power_mat;
magnitude = db2mag(decibels);

harmonics = magnitude(51:50:(40*50)+1);
harmonics_mat = [frequency(51:50:(40*50)+1)./50 harmonics];
save('PFC_harmonics.mat','harmonics_mat');

%% FFT Plot
figure(5)
bar(frequency(51:50:(40*50)+1)./50, harmonics, 0.1)
xlabel('Harmonic Order');
ylabel('Current (A)');
saveas(gcf,'PFC_AC_harmonics.jpeg')
