# Repository File Descriptions

- [Repository File Descriptions](#repository-file-descriptions)
  - [Coursework Excel CW_Workbook - An all encompassing workbook](#coursework-excel-cw_workbook---an-all-encompassing-workbook)
  - [BOM - Final bill of materials](#bom---final-bill-of-materials)
  - [Task 4: Ideal Boost](#task-4-ideal-boost)
    - [MATLAB script for choosing components: Ideal_Boost_Components.m](#matlab-script-for-choosing-components-ideal_boost_componentsm)
    - [SPICE Simulation: Ideal Boost SMPS](#spice-simulation-ideal-boost-smps)
    - [Simulation variants](#simulation-variants)
  - [Task 5, 6: Boost with real components](#task-5-6-boost-with-real-components)
    - [Choosing real components: 5_0_Choosing_Real_Components](#choosing-real-components-5_0_choosing_real_components)
    - [Choosing inductor core: Magnetics-Curve-Fit-Equation-Tool-2020](#choosing-inductor-core-magnetics-curve-fit-equation-tool-2020)
    - [SPICE simulation with real components: Boost_SMPS](#spice-simulation-with-real-components-boost_smps)
    - [Simulation variants](#simulation-variants-1)
  - [Task 7: CL control for Boost](#task-7-cl-control-for-boost)
    - [MATLAB control design: 7_2_CL_Boost_MATLAB/boost_cl_redo/Boost_transfer_function](#matlab-control-design-7_2_cl_boost_matlabboost_cl_redoboost_transfer_function)
    - [SPICE simulations for CL Boost](#spice-simulations-for-cl-boost)
  - [Task 8: Flyback](#task-8-flyback)
    - [Choosing components: flyback_components.m](#choosing-components-flyback_componentsm)
    - [SPICE Simulation: Variants](#spice-simulation-variants)
    - [MATLAB Controller design: 8_2_Flyback_MATLAB/flyback_ss_simplify.m](#matlab-controller-design-8_2_flyback_matlabflyback_ss_simplifym)
  - [Task 9: PFC](#task-9-pfc)
  - [Task 10: Combining everything together](#task-10-combining-everything-together)

## [Coursework Excel CW_Workbook](CW_Workbook.xlsx) - An all encompassing workbook

This workbook contains:

1. Output voltage rail specification (copied from coursework manual)
2. (Ideal Boost) Efficiency at various loads, various vin, startup behaviour
3. Component selection summary
4. `Task6_Cores`: Inductor core selection, following the specifications in [Magnetic Poder Core Catalog](5_0_Choosing_Real_Components\Magnetics-Powder-Core-Catalog-2020.pdf), and using the [curve fitting tool](5_0_Choosing_Real_Components\Magnetics-Curve-Fit-Equation-Tool-2020.xlsx)
5. Abandoned: `Task5_Inductor_Core` and `Task5_Inductors`: Used Magnetics' guide instead.
6. List of component selections for capacitor, diode and MOSFET. Data exported from Digikeys.

## [BOM](BOM.xlsx) - Final bill of materials

## Task 4: Ideal Boost

### MATLAB script for choosing components: [Ideal_Boost_Components.m](4_2_Ideal_Boost_SPICE/Ideal_Boost_Components.m)

Simple MATLAB script to generate the ideal inductance and capacitance value with the given specifications (power throughput, ripple, efficiency, operating frequency etc.)

### SPICE Simulation: [Ideal Boost SMPS](4_2_Ideal_Boost_SPICE/Boost%20SMPS.asc)

A SPICE circuit which models an ideal boost SMPS to meet the required power and ripple specifications. The measurements obtained are:

1. $V_{out}$ maximum and average, to confirm output voltage is as specified, startup behavior, and to verify efficiency
2. $I_c$ and $I_{Rload}$ average
3. $I_L$ to observe ripple is less than required
4. Finding settling time, rise time
5. Power input, output, efficiency

### Simulation variants

1. [Vary Ideal Boost SMPS Load](4_2_Ideal_Boost_SPICE/vary_Load)
2. [Ideal Boost SMPS with very low loads](4_2_Ideal_Boost_SPICE/very_Low_Loads)
3. [Vary Ideal Boost SMPS input voltage](4_2_Ideal_Boost_SPICE/vary_Vin)

In each folder, the LTSPice simulation is accompanied by their correponding MATLAB files for re-plotting the results.

## Task 5, 6: Boost with real components

### Choosing real components: [5_0_Choosing_Real_Components](5_0_Choosing_Real_Components/)

PDF datasheets for our selected capacitor, diode, MOSFET and inductor. What values do we need to extract from them to create the relevant models on SPICE?

### Choosing inductor core: [Magnetics-Curve-Fit-Equation-Tool-2020](5_0_Choosing_Real_Components/Magnetics-Curve-Fit-Equation-Tool-2020.xlsx)

Used in conjunction with the [Magnetics Powder Core manual](5_0_Choosing_Real_Components/Magnetics-Powder-Core-Catalog-2020.pdf) to determine and optimise the inductor core size, required windings and parameters such as resistance. Results outlined in `Task6_Cores` of [CW_Workbook](CW_Workbook.xlsx).

### SPICE simulation with real components: [Boost_SMPS](6_1_Real_Boost_SPICE/Boost%20SMPS.asc)

Similar to Ideal Boost SMPS, except we use real component values and attempt to implement the control signal. PID controller does not seem to work.

### Simulation variants

1. [Vary Real Boost SMPS Load](6_1_Real_Boost_SPICE/realBoost_VaryLoad)
2. [Real Boost SMPS Load with very low loads](6_1_Real_Boost_SPICE/realBoost_VeryLowLoad)
3. [Vary Real Boost SMPS input voltage](6_1_Real_Boost_SPICE/realBoost_VaryVin)

In each folder, the LTSPice simulation is accompanied by their correponding MATLAB files for re-plotting the results.

## Task 7: CL control for Boost

### MATLAB control design: [7_2_CL_Boost_MATLAB/boost_cl_redo/Boost_transfer_function](7_2_CL_Boost_MATLAB/boost_cl_redo/Boost_transfer_function.m)

1. Obtain state space model of Boost converter in ON and OFF state.
2. State space averaging
3. Transfer function for open loop state space model
4. Root locus of closed loop system, with only a proportional controller

### SPICE simulations for CL Boost

Stored in [7_3_Real_Boost_SPICE](7_3_Real_Boost_SPICE/): Boost_SMPS_ideal_ctrl


## Task 8: Flyback

### Choosing components: [flyback_components.m](8_2_Flyback_MATLAB/flyback_components.m)

Choosing the primary inductor coil, secondary inductor coils, ripple capacitor and load resistor.

### SPICE Simulation: Variants

1. Single rail, no control: [flyback single no controlled.asc](8_1_Flyback_SPICE/flyback single no controlled.asc)
2. Single rail, with control: [flyback single controlled.asc](8_1_Flyback_SPICE/flyback single controlled.asc.asc)
3. Single rail, with control, with varying load transients: [flyback single controlled varying transients.asc](8_1_Flyback_SPICE/flyback single controlled varying transients.asc)
4. All rails, no control: [BasicFlyBack_AllRails.asc](8_1_Flyback_SPICE/BasicFlyBack_AllRails.asc)
5. All rails, with control: [BasicFlyBack_AllRails_Controlled.asc](8_1_Flyback_SPICE/BasicFlyBack_AllRails_Controlled.asc)
6. All rails, with control, with varying load transients: [BasicFlyBack_AllRails_Controlled_vary.asc](8_1_Flyback_SPICE/BasicFlyBack_AllRails_Controlled_vary.asc)
7. All rails stacked, with no control: [BasicFlyBack_AllRails_Stacked.asc](8_3_Flyback_SPICE_Stacked/BasicFlyBack_AllRails_Stacked.asc)
8. All rails stacked, with control: [flyback - final.asc](8_3_Flyback_SPICE_Stacked/flyback - final.asc)

Again, each simulation is accompanied by their correponding MATLAB files for re-plotting the results.


### MATLAB Controller design: [8_2_Flyback_MATLAB/flyback_ss_simplify.m](8_2_Flyback_MATLAB/flyback_ss_simplify.m)

Also see variant called `flyback_ss_simplify_compare.m` to compare step responses at multiple loads. 

Also stored workings in [8_2_Flyback_MATLAB/flyback_workbook.xlsx](8_2_Flyback_MATLAB/flyback_workbook.xlsx). Contains:
1. Poles of flyback state space model at 100% load, 100V
2. Load resistors for achieving varying transients.

## Task 9: PFC

Recommend `Real PFC - fast.asc`. Result text files not commited.

## Task 10: Combining everything together

Recommend `final boost real`. Result text files not commited. Estimated run time is 3 hours.