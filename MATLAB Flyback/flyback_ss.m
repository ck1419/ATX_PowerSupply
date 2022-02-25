syms L_eq1;
syms r_eq1;
syms r_m1;
syms L_m1;
syms L_1;
syms L_eq2;
syms r_eq2;
syms C;
syms r_c;
syms R;
syms k_N;

syms big_d;
syms small_d;

L_2 = k_N^2 * L_1;

A_on = [-2*(L_eq1+r_eq1)/L_1, 0;
        0, -1/(C*(R+r_c))];
B_on = [1/L_1; 0];
C_on = [0, R/(R+r_c)];

% Non transformed
A_off = [1/L_2*(-R*r_c/(R+r_c)-L_eq2- r_eq2), - R/(L_2*(R+r_c));
        R/(C*(R+r_c)), -1/(C*(R+r_c))];
B_off = [0;0];
C_off = [R*r_c/(R+r_c), R/(R+r_c)];

% Transform to variables i_L1, v_c
T = [1/k_N 0; 0 1];
A_off_T = T * A_off * inv(T)
B_off_T = T * B_off
C_off_T = C * inv(T)

% State Space Averaging
A = big_d*A_on + (1-big_d)*A_off_T
B = big_d*B_on + (1-big_d)*B_off_T
C = big_d*C_on + (1-big_d)*C_off_T


L_eq1 = 0;
r_eq1 = 0;
r_m1  = 0;
L_m1  = 0;
L_1   = 0;
L_eq2 = 0;
r_eq2 = 0;
C     = 0;
r_c   = 0;
R     = 0;
k_N   = 0;
big_d = 0;

