# Repository File Descriptions

## [ATXOutputVoltageRailSpecifications](ATXOutputVoltageRailSpecifications.xlsx) - An all encompassing workbook

This workbook contains:

1. Output voltage rail specification (copied from coursework manual)
2. (Ideal Boost) Efficiency at various loads
3. (Ideal Boost) Startup behaviour
4. Component selection summary
5. `Task6_Cores`: Inductor core selection, following the specifications in [Magnetic Poder Core Catalog](Magnetics-Powder-Core-Catalog-2020.pdf), and using the [curve fitting tool](Magnetics-Curve-Fit-Equation-Tool-2020.xlsx)
6. Abandoned: `Task5_Inductor_Core` and `Task5_Inductors`
7. List of component selections for capacitor, diode and MOSFET. Data exported from Digikeys.

## [MATLAB Tests > Section4](MATLAB%20Tests/Section4.m) - For task 4

Simple MATLAB script to generate the ideal inductance and capacitance value with the given specifications (power throughput, ripple, efficiency, operating frequency etc.)

## [Ideal Boost SMPS](Ideal%20Boost%20SMPS/Boost%20SMPS.asc) - For tasks 4

A SPICE circuit which models an ideal boost SMPS to meet the required power and ripple specifications. The measurements obtained are:

1. $V_{out}$ maximum and average, to confirm output voltage is as specified, startup behavior, and to verify efficiency
2. $I_c$ and $I_{Rload}$ average
3. $I_L$ to observe ripple is less than required
4. Finding settling time, rise time
5. Power input, output, efficiency

## Component Datasheets - for task 5,6

PDF datasheets for our selected capacitor, diode, MOSFET and inductor. What values do we need to extract from them to create the relevant models on SPICE?

## [Magnetics-Curve-Fit-Equation-Tool-2020](Magnetics-Curve-Fit-Equation-Tool-2020.xlsx) - For task 5

Used in conjunction with the "Magnetics Powder Core" manual to determine and optimise the inductor core size, required windings and more.

## [Real Boost SMPS](Real%20Boost%20SMPS/Boost%20SMPS.asc) - For task 6,7

Similar to Ideal Boost SMPS, except we use real component values and attempt to implement the control signal. PID controller does not seem to work.

## [Control System (MATLAB)](Control%20System/Boost_transfer_function.m) - For task 7

1. Obtain state space model of Boost converter in ON and OFF state.
2. State space averaging
3. Transfer function for open loop state space model
4. Root locus of closed loop system, with only a proportional controller

> What is the unit step response thing doing?

## README.md

Our lab notebook. Only edit on hackmd.io

> Main task: Use 50kHz instead of 100kHz?
