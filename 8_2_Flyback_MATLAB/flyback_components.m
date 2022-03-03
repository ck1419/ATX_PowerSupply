clc; clf; close all; clear all;

V_out = [5, -5 , 12, -12, 3.3];
ripple_vout = [50e-3, 50e-3, 120e-3, 120e-3, 50e-3];
I_out = [35, 0.5, 28, 1, 34];

% Inductor
L_prim = 1.1e-3;
L_sec = (V_out./400).^2 .* L_prim;

% Capacitor
Delta = 0.5;
f_sw = 100e+3;
cap = Delta .* I_out ./ f_sw ./ ripple_vout;

% Resistor
resistor = V_out ./ I_out;