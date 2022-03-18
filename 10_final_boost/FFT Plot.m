close all; 
clear all;
clc;

%% FFT Data

FFT = readcell('final boost results FFT.txt');
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
save('final_harmonics.mat','harmonics_mat');

%% FFT Plot
figure(5)
bar(frequency(51:50:(40*50)+1)./50, harmonics, 0.1)
xlabel('Harmonic Order');
ylabel('Current (A)');
saveas(gcf,'final_AC_harmonics.jpeg')