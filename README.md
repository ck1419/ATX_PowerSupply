ATX_PowerSupply

Table of Contents
- [1. Overall Specifications for Power Supply](#1-overall-specifications-for-power-supply)
- [2. Stage 1: Boost Converter](#2-stage-1-boost-converter)
  - [2.1. Specifications](#21-specifications)
  - [2.2. Component Values](#22-component-values)
  - [2.3. Open Loop Simulations on LTSpice](#23-open-loop-simulations-on-ltspice)

# 1. Overall Specifications for Power Supply

- Work for mains inputs 100-250V, 50-60Hz
- Power rails: -5, +5, -12, +12, +3.3
  - 5V on whenever mains is plugged in, others on when the computer power switch is pressed.
  - Ripple current and tolerance for supply voltage specified in table 1.
- Main Stages
  1. Boost converter
  2. Power factor correction stage (ensures that the current waveform pulled from the mains is in phase with, and the same shape as, the voltage waveform)
  3. Flyback converter with multiple secondary windings on the high frequency transformer to generate multiple voltage rails.

| Supply (V) | Tolerance (%) | Tolerance (V) | Ripple p-p max (mV) | Current (A) | Output Pwr (W) | Max Output Pwr (W) | Notes   |
| ---------- | ------------- | ------------- | ------------------- | ----------- | -------------- | ------------------ | ------- |
| 5          | 0.05          | 0.25          | 50                  | 35          | 175            | 185.5              |         |
| \-5        | 0.1           | 0.5           | 50                  | 0.5         | \-2.5          | \-2.225            |         |
| 12         | 0.05          | 0.6           | 120                 | 28          | 336            | 356.16             |         |
| \-12       | 0.1           | 1.2           | 120                 | 1           | \-12           | \-10.68            |         |
| 3.3        | 0.05          | 0.165         | 50                  | 34          | 112.2          | 119.51             |         |
| 5          | 0.05          | 0.25          | 50                  | 2           | 10             | 10.6               | Standby |

- Maximum output power is then 647.7W (adding up all the regular output powers)
- 100% load is 247Ω (using an output of 400V)

# 2. Stage 1: Boost Converter

## 2.1. Specifications

- $V_{in}$ Input voltage: 100 V to 350 V (wide input range that will later correspond to operation with different mains voltages).
- $V_{out}$ Output voltage: Fixed at 400 V (+/- 10 V which includes ripple voltage).
- $I_{out, max}$ Maximum output current: Set by ATX supply rail requirements in table 1.
- $\Delta I_{in}$ Input (Inductor) Current ripple: max 7.5% at maximum output power.
- $f_s$ Switching frequency : > 50 kHz.
  > Arbitrarily set $f_s$ to 100kHz for simulations.
- Efficiency > 93% at full load (to have a chance to meet the 85% overall efficiency
requirement)

## 2.2. Component Values

1. Inductor sizing: minimum inductor value as a function of $I_{in}$, $V_{in}$, $\delta$, $f_s$.

    $\Delta i_L = \frac{V_{in}}{{L}} t_{on} = \frac{V_{in}}{{L}} \frac{\delta}{f_s}$

    $L = V_{in} \Delta i_L \frac{\delta}{f_s}$

    $L = 2 V_{in} I_{in} \frac{\delta}{f_s}$ because at critical conduction $I_{in} = \frac{1}{2} \Delta i_L$

    Given that the maximum output power $P_{out,max}$ is 647.7W and the efficiency $\eta$ is 85%, then the maximum input power (which gives the worst case inductor rating) is $762W$. 
    
    The maximum duty cycle is then set such that the output voltage $V_{out}$ is 400V, and the input voltage $V_{in}$ is at a minimum of 100V.

    $\delta = 1- \frac{V_{in}}{V_{out}} = 75\%$
    
    Consequently, we get the minimum inductor value required to meet the maximum power requirement:

    $L = 2 \times 762 \times \frac{0.75}{100k}  = 11.43mH$
    
> We note that the maximum inductor value calculated using the DCM/CCM boundary condition is significantly larger than that required by the 7.5% ripple current ripple at maximum output power condition. For example, the largest input current is $762/100 = 7.62A$, which gives a ripple of $7.62 \times 0.075 = 571.5mA$, and hence a less stringent inductance size requirement.

2. Peak and RMS inductor currents
   1. Peak inductor current in steady state, CCM, is by definition:

        $I_p = I_{in} + \frac{1}{2} \Delta i_L$

        Continuing from the calculations above, the corresponding input current, accounting for a minimum input voltage $V_{in}$ of 100V, is:

        $I_{in, max} = \frac{P_{in}}{V_{in}} = \frac{762}{100} = 7.62A$

        The ripple current with the inductor value selected is:

        $\Delta i_L = \frac{V_{in}}{{L}} \frac{\delta}{f_s} = \frac{100}{11.43m} \frac{0.75}{100k} = 65.61680mA \approx 65.6mA$

        With the input and ripple current caluclated, the peak inductor current is therefore:

        $I_p = 7.62 + 0.5 \times 65.61680m = 7.65281A \approx 7.65A$

   2. RMS (average) inductor current in steady state
   
        $I_{RMS} = \frac{\Delta i_L}{\sqrt{3}} + I_P - \Delta i_L = \frac{65.6m}{\sqrt{3}} + 7.65 - 65.6m = 7.62227 \approx 7.62A$

   3. Inductor core size

        $L = \frac{N^2 \mu A}{l}$
        
        Closed loop core (toroid) vs solenoid and air core.

   4. Why is this (peak and RMS current) important?

        By definition the average inductor current is the ceiling for the average input current. The inductor will need to handle the peak and RMS currents over the full range of $V_{in}$ and $V_{out}$, at the specified switching frequency. The higher the ripple (irrelevant to the average value), the higher the RMS value, which means more heating. Therefore we need to ensure that it is higher than the continuous input current.

3. Capacitor sizing: as a function of $\delta$, $f_s$, $I_{out}$ (Load current), $\Delta V_{ESR}$ voltage ripple.
        
    $C = \frac{\delta I_{out}}{f_s \Delta v_c}$

    The maximum output current, at a maximum output power $P_{out,max}$ of 336W and output voltage $V_{out}$ of 400V, is:

    $I_{out, max} = \frac{P_{out,max}}{V_{out}} = \frac{647.7}{400} = 1.61925A \approx 1.62A$

    Given a switching frequency of 100kHz and a maximum voltage ripple $\Delta V_{ESR}$ of 10V (?), then: 

    $C = \frac{\delta I_{out}}{f_s \Delta v_c} = \frac{0.75 \times 1.61925}{100k \times 10} = 1.21444 \mu F \approx 1.21 \mu F$ 

4. Switch and diode selection: Maximum current and voltage blocking capability for switch and diode.
   1. Maximum voltage blocking capability: Both $V_{max} = V_{out} = 400V$.
      1. For the MOSFET: When the MOSFET is OFF,  it is held at $V_{out}$ (plus a small diode drop).
      2. For the diode: When the MOSFET is ON, the positive terminal is held at a value near ground, and the negative terminal is held at $V_{out}$.
   2. Maximum current blocking capability: $I_{max} = I_{in} + \frac{1}{2} \Delta i_L = 7.65A$
        - In both cases, the device will have to block the maximum inductor current since that is the input current.


## 2.3. Open Loop Simulations on LTSpice

For this section, the simulation has been performed with 1,5,10,50,60,70,80,90,100% load. The raw experiment results are as follows:

```
Direct Newton iteration for .op point succeeded.
.step x=2.47
.step x=12.35
.step x=24.7
.step x=123.5
.step x=148.2
.step x=172.9
.step x=197.6
.step x=222.3
.step x=247


Measurement: voutmax
  step	MAX(v(vout))	FROM	TO
     1	158.836	0	0.02
     2	233.455	0	0.02
     3	297.37	0	0.02
     4	387.168	0	0.02
     5	397.968	0	0.02
     6	402.207	0	0.02
     7	405.423	0	0.02
     8	407.952	0	0.02
     9	409.983	0	0.02

Measurement: voutavg
  step	AVG(v(vout))	FROM	TO
     1	88.3454	0.015	0.02
     2	179.641	0.015	0.02
     3	259.556	0.015	0.02
     4	377.67	0.015	0.02
     5	388.214	0.015	0.02
     6	393.375	0.015	0.02
     7	397.339	0.015	0.02
     8	400.479	0.015	0.02
     9	403.027	0.015	0.02

Measurement: ic_avg
  step	AVG(i(c1))	FROM	TO
     1	-0.106624	0.015	0.02
     2	-0.124864	0.015	0.02
     3	0.0318687	0.015	0.02
     4	-0.0100427	0.015	0.02
     5	-0.00179259	0.015	0.02
     6	-0.000511156	0.015	0.02
     7	0.000453232	0.015	0.02
     8	0.00120608	0.015	0.02
     9	0.00181104	0.015	0.02

Measurement: irload_avg
  step	AVG(i(rload))	FROM	TO
     1	35.7674	0.015	0.02
     2	14.5458	0.015	0.02
     3	10.5083	0.015	0.02
     4	3.05805	0.015	0.02
     5	2.61953	0.015	0.02
     6	2.27516	0.015	0.02
     7	2.01082	0.015	0.02
     8	1.80152	0.015	0.02
     9	1.63169	0.015	0.02

Measurement: il_avg
  step	AVG(i(l1))	FROM	TO
     1	92.0614	0.015	0.02
     2	61.2578	0.015	0.02
     3	44.8744	0.015	0.02
     4	13.1896	0.015	0.02
     5	11.3059	0.015	0.02
     6	9.83076	0.015	0.02
     7	8.69834	0.015	0.02
     8	7.80164	0.015	0.02
     9	7.074	0.015	0.02

```

![](https://i.imgur.com/HKzkL3b.png)

![](https://i.imgur.com/kkueMC4.png)
![](https://i.imgur.com/cpNSsBG.png)

![](https://i.imgur.com/9Lc3nUY.png)
![](https://i.imgur.com/acA4NRu.png)



1. Efficiency in required range of operating conditions

    | $R_{load}$ ($\Omega$) | $V_{in}$ (V) | $I_{in}$ (A) | $V_{out}$ (V) | $I_{out}$ (A) | Efficiency $\eta$ |
    | ----------------------- | ------------- | ------------- | -------------- | -------------- | ------------------ |
    | 2.47                    | 100           | 92.0614       | 88.3454        | 35.7674        | 0.343236716        |
    | 12.35                   | 100           | 61.2578       | 179.641        | 14.5458        | 0.426561525        |
    | 24.7                    | 100           | 44.8744       | 259.556        | 10.5083        | 0.607805857        |
    | 123.5                   | 100           | 13.1896       | 377.67         | 3.05805        | 0.875639704        |
    | 148.2                   | 100           | 11.3059       | 388.214        | 2.61953        | 0.899475689        |
    | 172.9                   | 100           | 9.83076       | 393.375        | 2.27516        | 0.910398652        |
    | 197.6                   | 100           | 8.69834       | 397.339        | 2.01082        | 0.918539869        |
    | 222.3                   | 100           | 7.80164       | 400.479        | 1.80152        | 0.92476829         |
    | 247                     | 100           | 7.074         | 403.027        | 1.63169        | 0.929622739        |
    
    > Old resitive loads, kept in case
    
    The efficiency is largely above 85% for loads between 50% and 100%, which agrees with the inputs defined to determine the inductor and capacitor values.

    | Power Load % | Resistor Value |
    | ------------ | -------------- |
    | 100          | 247.0          |
    | 90           | 274.5          |
    | 80           | 208.8          |
    | 70           | 352.9          |
    | 60           | 411.7          |
    | 50           | 494.1          |
    
    > New resistor values, finish table with actual values once inductor value calculated

3. Startup behaviour (assuming output capacitor and inductor are in a discharged state).

    Transfer function from TI Website: $G(s) = \frac{V_{o}(s)}{\delta (s)} = \frac{V_{out}^2}{V_{in}} \frac{(1+ s r_c C) (1-s \frac{L}{R} ({\frac{V_{out}}{V_{in}}})^2)}{1+ \frac{s}{\omega_0 Q} + \frac{s^2}{\omega_0^2}}$
    
    Ignoring the parasitics, the transfer function is: $G(s) = \frac{V_{o}(s)}{\delta (s)} = \frac{V_{out}^2}{V_{in}} \frac{1-s \frac{L}{R} ({\frac{V_{out}}{V_{in}}})^2}{1+ s \frac{L}{R} ({\frac{V_{out}}{V_{in}}})^2 + s^2 LC ({\frac{V_{out}}{V_{in}}})^2 }$
    
|                         |                |                     |               | Rise Time from 0.1 $V_{out}$ to 0.9$V_{out}$ |             |            | $Eta < 0.05 V_{out}$ |
| ----------------------- | -------------- | ------------------- | ------------- | ---------------------------------------------- | ----------- | ---------- | ----------------------- |
| $R_{load}$ ($\Omega$) | $V_{out}$ (V) | $V_{out, max}$ (V) | Overshoot (%) | Rise Time (s)                                  | FROM        | TO         | Settling Time (s)       |
| 2.47                    | 88.3454        | 158.836             | 0.797897797   | ~~-0.00133999~~                                | 0.00409017  | 0.00275017 | ~~0.0199981~~           |
| 12.35                   | 179.641        | 233.455             | 0.299564131   | ~~0.0046~~                                     | 0.00341025  | 0.00801025 | ~~0.0199986~~           |
| 24.7                    | 259.556        | 297.37              | 0.145687251   | ~~0.00604003~~                                 | 0.00211016  | 0.00815018 | ~~0.0199984~~           |
| 123.5                   | 377.67         | 387.168             | 0.02514894    | 0.0026602                                      | 0.000649987 | 0.00331019 | 0.00514785              |
| 148.2                   | 388.214        | 397.968             | 0.025125317   | 0.00228069                                     | 0.000599527 | 0.00288022 | 0.00414786              |
| 172.9                   | 393.375        | 402.207             | 0.022451859   | 0.0019201                                      | 0.000549968 | 0.00247007 | 0.0034279               |
| 197.6                   | 397.339        | 405.423             | 0.020345347   | 0.0016203                                      | 0.000519787 | 0.00214008 | 0.00281791              |
| 222.3                   | 400.479        | 407.952             | 0.018660154   | 0.00139993                                     | 0.000490101 | 0.00189003 | 0.00234793              |
| 247                     | 403.027        | 409.983             | 0.01725939    | 0.00123019                                     | 0.000469821 | 0.00170001 | 0.00200796              |

   1. Percentage overshoot of output voltage
   2. Rise and settling time of output voltage
   3. Oscillation frequency of output voltage
   
   In general, the ideal boost converter can be expressed with a second order transfer function (between the output voltage and the duty cycle) in the form:
   
   $$G(s) = \frac{\varrho}{s^2 + 2 \zeta \omega_n s + \omega_n^2}$$
   
   This immediately relates the output voltage with the natural oscillation frequency $\omega_n$ and damping ratio $\zeta$. Using approximations in control frequency, the rise (10-90%) $t_{r, 10-90\%}$ and settling time (to an oscillation margin of 5%) $t_{s, 5\%}$, as well as percentage overshoot $\%OS$, is related to the damping ratio and the natural (oscillation) frequency as follows:
   
   $$t_{s, 5\%} = \frac{3}{\zeta \omega_n}$$
   $$\%OS = 100 \times exp(-\frac{\zeta \pi}{\sqrt{1-\zeta^2}})$$
   
   The rise time is hard to derive.
    
4. Change in loads: very large and small loads (variation of output voltage w.r.t. fixed duty cycle). Stepped load changes between
   1. 50% load
   2. 100% load
   
   Since the maximum power delivered $P_{out}$ is 647.7W, and the output voltage $V_{out}$ is 400V, the associated maximum load is:

   $R = \frac{V_{out}^2}{P_{out}} = 247.02795 \Omega \approx 247 \Omega$
   
   
   
5. How converter operates under very low loads.

    The steady state error is smallest for 100% load, and its rise time, overshoot and settling time is the smallest. At very low loads, the current is very large, which increases the heat dissipated in the semiconductor devices and reduces the efficiency. Another way to visualise this is that the capacitor becomes short circuited as the load continues to drop, which means that it cannot store any energy, which reduces the output voltage.

## 2.4 Real component choices

| Component | Value | Units | Parasitic resistance | Link | Notes |
| --------- | ----- | ----- | -------------------- | ---- | ----- |
| MOSFET    |       |       |                      |      |       |
| Capacitor |       |       |                      |      |       |
| Inductor  |       |       |                      |      |       |
| Diode     |       |       |                      |      |       |

# References

1. http://electronicsbeliever.com/how-to-select-inductor-for-boost-converter/
