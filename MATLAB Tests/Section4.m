% Maximum Output Power is 175W

P_o = 175;
V_o = 400;
Eff = 0.85;
f_s = 100e3;
v_orip = 10;

I_o = P_o/V_o;
P_i = P_o/Eff;

V_i = 100; % adjust this

duty = 1 - V_i/V_o;

L = 2 * P_i * duty / f_s;

C = duty * I_o / f_s / v_orip;