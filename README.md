# Cold-Chain Temperature Excursion Duration Monitor Using Sequential Digital Logic

A Verilog RTL-based digital monitoring system designed to detect and track temperature excursions in cold-chain storage and transportation environments. The project demonstrates sequential logic design, RTL simulation, gate-level verification, and ASIC physical implementation using the SKY130A PDK and OpenLane.

## Table of Contents

- [Overview](#overview)
- [Motivation](#motivation)
- [Objectives](#objectives)
- [Cold-Chain Monitoring Background](#cold-chain-monitoring-background)
- [System Architecture](#system-architecture)
- [Functional Description](#functional-description)
- [Digital Design Concepts](#digital-design-concepts)
- [Design Specifications](#design-specifications)
- [RTL Design Methodology](#rtl-design-methodology)
- [Verification Methodology](#verification-methodology)
- [ASIC Physical Design Flow](#asic-physical-design-flow)
- [Implementation Results](#implementation-results)
- [Waveforms and Design Visualizations](#waveforms-and-design-visualizations)
- [Repository Structure](#repository-structure)
- [Tools and Technologies](#tools-and-technologies)
- [Implementation Workflow and Commands](#implementation-workflow-and-commands)
- [Project Demo Video](#project-demo-video)
- [Applications](#applications)
- [Limitations and Future Enhancements](#limitations-and-future-enhancements)
- [References](#references)
- [Author](#author)

## Overview

Cold-chain systems are used to store and transport temperature-sensitive products such as vaccines, medicines, biological samples, and perishable food. A temperature excursion occurs when the monitored temperature moves outside an acceptable operating range.

This project implements a digital temperature-excursion duration monitor using Verilog HDL and sequential digital logic. The design is taken through RTL simulation, gate-level simulation, and ASIC physical design using the SKY130A standard-cell platform and OpenLane.

The project demonstrates how a digital hardware design can progress from RTL description to a physically implemented layout.

> **Project scope:** This repository focuses on the digital monitoring logic and its ASIC implementation. It does not include a physical temperature sensor, analog interface, or a complete deployed cold-chain monitoring product.

## Motivation

Temperature excursions can affect the quality, safety, and effectiveness of temperature-sensitive products. Recording only the current temperature may not be sufficient; the duration of an excursion can also be important.

A hardware-based monitoring block can track excursion-related digital events using clocked logic. This project explores that concept through a compact RTL design and a standard-cell ASIC implementation flow.

## Objectives

- Design a sequential digital monitoring block using Verilog HDL.
- Implement excursion-related state and duration-tracking logic.
- Verify the RTL using a dedicated testbench.
- Perform gate-level simulation to validate the synthesized logic.
- Synthesize the RTL into a standard-cell netlist.
- Execute the ASIC physical design flow using OpenLane and SKY130A.
- Generate physical design artifacts such as GDS, DEF, and SPEF.
- Review implementation reports and document the results.

## Cold-Chain Monitoring Background

A cold-chain monitoring system observes whether a temperature remains within a specified operating range.

Let:

- \(T(t)\) represent the measured temperature at time \(t\).
- \(T_{\min}\) represent the minimum acceptable temperature.
- \(T_{\max}\) represent the maximum acceptable temperature.

A general temperature-range condition can be expressed as:

\[
T_{\min} \leq T(t) \leq T_{\max}
\]

A temperature excursion occurs when the measured temperature falls below the minimum or rises above the maximum acceptable limit.

For a digital implementation, a temperature sensor or upstream interface must convert the physical measurement into a digital representation or status signal. The RTL can then process that information synchronously.

**Important:** The exact temperature thresholds, duration units, counter width, and excursion-reset behavior must follow the implemented RTL and its configuration. This project should not be interpreted as a medically validated temperature-monitoring device.

## Objectives of the Digital Monitor

The intended hardware concept is to:

1. Receive a digital temperature-status input.
2. Sample the input using a clock.
3. Maintain the necessary sequential state.
4. Track excursion-related duration or elapsed clock cycles.
5. Provide a digital indication of the monitored condition.
6. Reset the internal state using the reset input.

The precise behavior of the implemented module is defined by the RTL source in `src/cold_chain_temp_monitor.v`.

## System Architecture

At a conceptual level, the monitoring block consists of a clocked digital input, sequential monitoring logic, internal state, and output indication.

```text
        Digital Temperature Status
                    |
                    v
        +------------------------+
        | Input Sampling /       |
        | Condition Evaluation   |
        +------------------------+
                    |
                    v
        +------------------------+
        | Sequential Monitoring  |
        | and Duration Tracking  |
        +------------------------+
                    |
                    v
        +------------------------+
        | Status / Alarm Output  |
        +------------------------+

       Clock and Reset control the
       sequential monitoring logic
```

## Functional Description

### Clock

The clock provides the timing reference for synchronous state updates. Sequential logic updates according to the active clock edge specified in the RTL.

### Reset

The reset initializes the internal state to a known condition. The reset polarity and whether it is synchronous or asynchronous are determined by the RTL implementation.

### Temperature-status input

The monitoring logic receives a digital representation of the temperature condition. The interface between a physical sensor and this digital input is outside the current project's scope unless separately implemented.

### Sequential monitoring

Sequential logic retains state between clock edges. Depending on the implemented RTL, registers and counters can be used to track the duration of an excursion and maintain monitoring status.

### Output indication

The output reports a monitoring condition according to the logic defined in the RTL. Its exact assertion, deassertion, and reset behavior should be interpreted from the source code and verified waveforms.

## Digital Design Concepts

### Combinational logic

Combinational logic computes outputs from the current input and internal-state values without independently storing state.

### Sequential logic

Sequential logic stores information in flip-flops and updates it in response to clock and reset events.

### Counters and duration tracking

A digital duration monitor can represent elapsed time as a count of clock cycles. If the clock frequency is \(f_{\text{clk}}\), the clock period is:

\[
T_{\text{clk}}=\frac{1}{f_{\text{clk}}}
\]

For a counter that increments once per clock cycle, an elapsed count of \(N\) cycles corresponds to:

\[
t_{\text{elapsed}}=\frac{N}{f_{\text{clk}}}
\]

This conversion applies when the counter increments once per clock cycle without pauses. The actual relationship must account for the implemented counter behavior and clock frequency.

### Finite-state and control logic

A sequential monitoring design may use control states to represent operating conditions. The exact state encoding and whether the current implementation uses an explicit finite-state machine must be confirmed from the RTL.

## Design Specifications

| Parameter | Description |
|---|---|
| Project name | Cold-Chain Temperature Excursion Duration Monitor |
| HDL | Verilog |
| Design style | Sequential digital logic |
| RTL source | `src/cold_chain_temp_monitor.v` |
| RTL testbench | `verification/tb_cold_chain_temp_monitor.v` |
| Gate-level testbench | `verification/tb_cold_chain_temp_monitor_gls.v` |
| Target technology | SKY130A |
| ASIC flow | OpenLane |
| Physical design output | GDS, DEF, SPEF |
| Verification | RTL simulation and gate-level simulation |

The precise clock frequency, counter width, threshold values, and output timing should be documented from the final RTL and configuration files.

## RTL Design Methodology

The design is described using Verilog HDL and organized as a synthesizable RTL module.

The RTL design process includes:

1. Defining the module interface.
2. Implementing clocked monitoring logic.
3. Defining reset behavior.
4. Implementing the required internal state and duration-tracking behavior.
5. Connecting the monitored condition to the appropriate output logic.
6. Simulating the design before synthesis.
7. Synthesizing the RTL into a standard-cell implementation.

The main source file is:

`src/cold_chain_temp_monitor.v`

The OpenLane configuration and pin-order files are provided in the repository root and `docs/`.

## Verification Methodology

Verification is performed at two levels.

### 1. RTL simulation

RTL simulation evaluates the behavior of the Verilog design before technology mapping.

Testbench:

`verification/tb_cold_chain_temp_monitor.v`

Waveform data:

`verification/cold_chain_temp_monitor.vcd`

The recorded project verification result is **20/20 tests passed**.

### 2. Gate-level simulation

Gate-level simulation evaluates the synthesized logic using a gate-level netlist and a dedicated testbench.

Testbench:

`verification/tb_cold_chain_temp_monitor_gls.v`

Waveform data:

`verification/cold_chain_temp_monitor_gls.vcd`

The recorded project verification result is **20/20 tests passed**.

### Verification coverage

The testbenches should be inspected to determine exactly which conditions are covered. Relevant scenarios to document include reset behavior, normal input conditions, excursion assertion, duration tracking, and recovery from an excursion, where those cases are implemented in the tests.

Passing simulation tests demonstrates that the design passed the executed test cases; it does not establish exhaustive functional coverage or prove behavior for every possible input sequence.

## ASIC Physical Design Flow

The design was implemented using OpenLane with the SKY130A process design kit.

The standard ASIC flow consists of the following stages:

1. **RTL preparation:** Load the Verilog source and design configuration.
2. **Synthesis:** Convert RTL into a technology-mapped standard-cell netlist.
3. **Floorplanning:** Define the core and die dimensions and prepare the initial layout.
4. **Power planning:** Build the power-distribution structures.
5. **Placement:** Place the standard cells within the floorplan.
6. **Clock-tree synthesis:** Build the clock distribution network.
7. **Routing:** Connect the design using the available metal layers.
8. **Physical verification:** Run the applicable checks and inspect the generated reports.
9. **GDS generation:** Produce the layout database for the implemented design.

### Main implementation artifacts

- **Verilog netlist:** Technology-mapped representation of the logic.
- **DEF:** Design Exchange Format containing physical placement and routing information.
- **GDS:** Layout database containing the physical geometry.
- **SPEF:** Parasitic information used for timing analysis.
- **Reports:** Implementation summaries and timing-related results.

These files represent different stages and views of the same design; they are not interchangeable.

## Implementation Results

The recorded OpenLane run completed and generated the physical design outputs.

| Metric / Check | Recorded result |
|---|---:|
| OpenLane flow | Completed |
| RTL simulation | 20/20 tests passed |
| Gate-level simulation | 20/20 tests passed |
| TritonRoute violations | 0 |
| Shorts | 0 |
| Antenna violations | 0 |
| LVS errors | 0 |
| CVC errors | 0 |
| KLayout violations | 0 |
| Reported wire length | 482 |
| Reported vias | 126 |

The wire-length unit and the exact interpretation of the via count should be taken from the corresponding run reports. These figures are implementation results, not universal specifications of the design.

### Timing analysis

Post-route STA summary reports for TT, SS, and FF corners are included under `reports/post_route_sta/`.

## Waveforms and Design Visualizations
All the screenshots of waveforms, terminal logs, designs, evidences are in the screenshots folder

Waveform screenshots and a schematic image can be added here after exporting them from the simulation and synthesis tools.

### RTL simulation waveform

Shows the clock, reset, temperature-status input, and relevant output signals during RTL simulation.

### Gate-level simulation waveform

Shows the corresponding signals during gate-level simulation.

### Synthesized netlist schematic

A schematic generated from the synthesized netlist can illustrate the mapped sequential and combinational logic.

### Physical layout

The generated GDS layout can be viewed in a layout viewer such as KLayout.

## Repository Structure

```text
cold-chain-temperature-monitor/
├── docs/
│   ├── config.tcl
│   └── pin_order.cfg
├── reports/
│   ├── openlane/
│   │   └── final_summary_report.csv
│   └── post_route_sta/
├── results/
│   ├── layout/
│   │   ├── cold_chain_temp_monitor.def
│   │   ├── cold_chain_temp_monitor.gds
│   │   └── cold_chain_temp_monitor.spef
│   └── netlist/
│       ├── cold_chain_temp_monitor_generic.v
│       ├── cold_chain_temp_monitor_gls.v
│       └── cold_chain_temp_monitor.synthesis.v
├── runs/
├── screenshots/
├── src/
│   └── cold_chain_temp_monitor.v
├── verification/
│   ├── tb_cold_chain_temp_monitor.v
│   ├── tb_cold_chain_temp_monitor_gls.v
│   ├── cold_chain_temp_monitor.vcd
│   └── cold_chain_temp_monitor_gls.vcd
├── config.tcl
├── pin_order.cfg
└── README.md
```

The exact contents of `runs/`, `screenshots/`, and the report directories may vary depending on which generated artifacts are committed to the repository.

## Tools and Technologies

- **Verilog HDL:** RTL design and digital logic description.
- **RTL simulation tools:** Functional simulation and waveform generation.
- **Gate-level simulation tools:** Verification of the synthesized netlist.
- **OpenLane:** Automated RTL-to-GDS ASIC implementation flow.
- **SKY130A PDK:** Open-source 130 nm-class process design kit and standard-cell technology.
- **KLayout:** Physical layout viewing and inspection.
- **STA tools and reports:** Timing analysis using timing constraints, cell libraries, and extracted parasitics.

Tool versions and exact commands can be documented in a reproducibility section after confirming the versions used for the final run.

## Implementation Workflow and Commands

This section documents the major milestones followed during the development and physical implementation of the Cold-Chain Temperature Excursion Duration Monitor.


### Milestone 1: Project Setup and Directory Structure

Navigate to the project workspace and inspect the source files.

```bash
cd ~/Desktop/cold_chain_monitor

ls
ls src
ls verification
```

The RTL source, simulation testbenches, and waveform files were organized into separate directories.

### Milestone 2: RTL Design

The main Verilog module was created and maintained at:

```text
src/cold_chain_temp_monitor.v
```

Inspect the RTL:

```bash
cat src/cold_chain_temp_monitor.v
```

The design describes the sequential monitoring logic, clock/reset behavior, and outputs.

### Milestone 3: RTL Simulation

The RTL testbench was used to verify the design before synthesis.

```text
verification/tb_cold_chain_temp_monitor.v
```

The testbench generated VCD waveform data for signal inspection.

```text
verification/cold_chain_temp_monitor.vcd
```

If the waveform was generated in the current directory, move or copy it into `verification/` as needed.

**Recorded result:** 20/20 RTL simulation tests passed.

### Milestone 4: Gate-Level Simulation (GLS)

The synthesized gate-level design was checked using a separate testbench.

```text
verification/tb_cold_chain_temp_monitor_gls.v
```

Technology-mapped netlists may require additional SKY130 standard-cell simulation models and appropriate compile options.

The gate-level waveform file is:

```text
verification/cold_chain_temp_monitor_gls.vcd
```

**Recorded result:** 20/20 gate-level simulation tests passed.

### Milestone 5: OpenLane Configuration

The physical design project was configured using OpenLane 1.x and the SKY130A PDK.

Configuration files:

```text
config.tcl
pin_order.cfg
docs/config.tcl
docs/pin_order.cfg
```

The OpenLane project directory was:

```bash
cd /home/vsduser/Desktop/work/tools/openlane_working_dir/openlane/designs/cold_chain_temp_monitor
```

Inspect the configuration:

```bash
cat config.tcl
cat pin_order.cfg
```

### Milestone 6: ASIC Physical Design Flow

The design was processed through the OpenLane RTL-to-GDS flow, including synthesis, floorplanning, placement, clock-tree synthesis, routing, and physical verification.

A typical OpenLane 1.x launch command is:

```bash
openlane config.tcl
```

The recorded run directory was:

```text
runs/23-10_10-27/
```

### Milestone 7: Inspecting Generated Results

After the physical design flow, the generated files were inspected.

```bash
ls results
ls results/synthesis
ls results/routing
ls results/klayout
ls reports
```

Important generated artifacts included:

```text
results/synthesis/cold_chain_temp_monitor.synthesis_cts.v
results/routing/cold_chain_temp_monitor.def
results/routing/cold_chain_temp_monitor.spef
results/klayout/cold_chain_temp_monitor.gds
results/magic/cold_chain_temp_monitor.gds
```

The repository also contains organized copies of the final netlist, layout, and parasitic files under `results/netlist/` and `results/layout/`.

### Milestone 8: Physical Verification and Reports

The final implementation summary and physical verification results were reviewed.

```text
reports/openlane/final_summary_report.csv
```

The recorded flow reported zero TritonRoute violations, shorts, antenna violations, LVS errors, CVC errors, and KLayout violations.

These results correspond to the recorded implementation run and should be verified against the committed summary report when reproducing the project.

### Milestone 9: Post-Route Timing Analysis

Post-route timing summary reports were prepared for the TT, SS, and FF corners.

```text
reports/post_route_sta/tt_summary.rpt
reports/post_route_sta/ss_summary.rpt
reports/post_route_sta/ff_summary.rpt
```

### Milestone 10: Viewing the Physical Layout

The generated GDS was opened in KLayout for visual inspection.

The relevant layout file was:

```text
results/klayout/cold_chain_temp_monitor.gds
```

The layout screenshot was saved in the project's screenshots collection for documentation.

### Milestone 11: Organizing the GitHub Repository

The project files were organized into source, verification, results, reports, documentation, and screenshots directories.

```bash
git status
git add .
git commit -m "Add cold-chain temperature monitor RTL and physical design"
git push -u origin main
```

The repository was published on GitHub:

https://github.com/sravanimannempalli/cold-chain-temperature-monitor

### Final Outcome

The project completed RTL verification, gate-level verification, and the OpenLane physical design flow. The repository contains the RTL source, testbenches, waveform data, netlists, physical layout files, parasitic data, and implementation reports.

## Project Demo Video

Watch the complete project demonstration, from Verilog RTL simulation to the final GDS layout.

[▶ Watch the Project Demo on Google Drive](https://drive.google.com/file/d/1_KqHNOxbfTFj8Vq-QfOSUuIpifURai-I/view?usp=drive_link)
## Applications

The digital monitoring concept is relevant to:

- Vaccine and pharmaceutical cold-chain monitoring.
- Temperature-sensitive storage systems.
- Food transportation and refrigeration monitoring.
- Laboratory sample storage.
- Digital hardware prototyping for environmental monitoring.

These are potential application areas. The current RTL implementation is a digital design demonstration and is not a certified monitoring product.

## Limitations and Future Enhancements

Possible future improvements include:

- Integrating a real temperature sensor and digital interface.
- Adding configurable temperature limits.
- Making excursion-duration thresholds programmable.
- Adding a latched alarm and explicit alarm-clear behavior.
- Recording cumulative excursion duration.
- Adding communication interfaces for external monitoring.
- Expanding testbench coverage and adding assertions.
- Automating regression tests.
- Reviewing setup and hold timing across process corners.
- Adding area, power, and timing comparisons.
- Documenting exact tool versions and reproducible build commands.
- Adding exported RTL and gate-level waveform screenshots.
- Adding a generated synthesized-netlist schematic.

These are proposed enhancements and should not be interpreted as features already implemented.

## References

1. [OpenLane Documentation](https://openlane.readthedocs.io/)
2. [SkyWater SKY130 PDK](https://github.com/google/skywater-pdk)
3. [KLayout Documentation](https://www.klayout.de/doc.html)
4. [Verilog Hardware Description Language — IEEE 1364](https://standards.ieee.org/ieee/1364/)

## Author

**Sravani Mannempalli**

Project: **Cold-Chain Temperature Excursion Duration Monitor Using Sequential Digital Logic**

Built as a digital design and ASIC physical implementation project using Verilog, OpenLane, and SKY130A.
