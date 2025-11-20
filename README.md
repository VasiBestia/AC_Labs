🚀 Verilog Labs: Sequential & Arithmetic Logic (AC/SD) 🔢

Welcome to my repository for Computer Architecture (AC) / Digital Systems (SD) labs. This collection showcases fundamental digital circuits implemented in Verilog HDL, focusing on the construction and control of arithmetic components using sequential logic.

The goal was to master parameterization, FSM design, and synchronous data flow.

✨ Project Highlights

1. ⚙️ Finite State Machine (FSM) & Sequential Core

The most complex modules, demonstrating multi-cycle operation and state control.

Module

Core Functionality

Key Features

sequential_multiplier

Automatic 4-bit Multiplier

Uses an FSM to manage WRITE, MULTIPLY, and DISPLAY cycles, coordinating data transfer between registers.

Register

Parameterized Data Register

Synchronous data loading (we) and asynchronous output control (oe) for bus sharing.

sequential_multiplier_tb

FSM Testbench

Includes scenarios to verify priority logic and state transitions (e.g., WRITE has priority over MULTIPLY).

2. 🧮 Combinational Arithmetic

Building blocks for the ALU and larger arithmetic circuits.

Module

Functionality

Data Width

adder_4bit

4-bit Ripple Carry Adder

Implements standard binary addition by cascading 4 full adder cells.

comparator

1-bit Comparator

Generates explicit less, equal, and greater outputs for logic decisions.

comparator_Nbit

N-bit Comparator

Scalable implementation for comparing two N-bit vectors.

🔬 Running the Simulations

All modules are tested using dedicated testbenches (_tb.v) configured to generate waveform data.

Prerequisites

You need Icarus Verilog (iverilog) and GTKWave installed to run and view the results.

Step-by-Step Guide

Compile the Circuit: Include the main module and all its dependencies (e.g., Registers) along with the testbench.

# Example: Compiling the Sequential Multiplier
iverilog -o sim_output sequential_multiplier.v Register.v sequential_multiplier_tb.v


Run the Simulation: This executes the test cases and generates the waveform file (wave.vcd).

vvp sim_output


View the Waveforms: Open the generated file to analyze timing, FSM states, and signal integrity.

gtkwave wave.vcd


📌 Technical Details

Language: Verilog HDL

Time Unit: 1ns / 1ps

Clock: CLK_PERIOD = 10ns (100 MHz)

Code Style: All modules are designed to be fully synchronous where required (registers) and purely combinational for logic gates (adders, comparators).

Developed by Vasilescu Alexandru-Gabriel/333AA for Digital Systems. | Academic Year 2025 III
