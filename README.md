# Virtualized Computing Fabric

## Overview

A VHDL-based 5×3 reconfigurable computing fabric designed to execute a 10-stage computational dataflow through hardware reuse across two computational passes.

The architecture integrates 15 specialized computational units, configurable operand routing, clock-controlled storage, and feedback paths to support hardware virtualization.

## Architecture

- 5×3 array of 15 computational units
- 4-bit data width
- Three specialized computational unit types
- Configurable operand routing using 2:1 and 4:1 multiplexers
- Dedicated operand, operation, and output registers
- Feedback paths from the final row to the first row
- Two-pass execution supporting a 10-stage computational dataflow

## Functional Verification

The design was simulated in Vivado using a VHDL testbench that configures computational operations, controls operand routing, sequences register write enables, and verifies final outputs using assertions.

| Computational Pass | Column 0 | Column 1 | Column 2 |
|---|---|---|---|
| Run 1 | 1111 | 1100 | 1111 |
| Run 2 | 1011 | 0001 | 1010 |

The second pass reuses the results of the first pass through the external input ports.

## Tools and Technologies

- VHDL
- AMD Vivado
- RTL Design
- Behavioral Simulation
- Assertion-Based Verification

## Repository Structure

- `rtl/` — VHDL design source files
- `sim/` — Functional simulation testbench
- `docs/` — Original project documentation and architecture diagrams
- `results/` — Simulation waveform screenshots

## Project Status

This repository contains the original academic implementation. Future development will focus on RTL refactoring, expanded functional verification, and feedback-path validation.
