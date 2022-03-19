clear all; close all; clc;

% General Controller = g * (k1 + k2/(1+Ts))
% Lead lag general form = gain * (s - zero)/(s - pole)

g = 0.00083;
zero = 8000;
factor = 2.65;

pole = -zero*factor;

T = -1/pole
k_1 = g
k_2 = (k_1*T*zero) + k_1
gain = k_1