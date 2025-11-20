🖥️ Digital Logic Design Labs (Verilog HDL)

This repository contains the results of the laboratory assignments for the Computer Architecture (AC) / Digital Logic Design (DLD) course. The implementations are designed in Verilog HDL and simulated using iverilog/GTKWave.

The focus of these labs is to understand and implement fundamental arithmetic and sequential logic circuits.

🛠️ Implemented Modules

Below is a list of the core modules implemented, grouped by type.

1. 🔢 Arithmetic Logic Unit (ALU) Components

These modules perform basic arithmetic and comparison operations.

Module

Description

Key Features

full_adder

Basic full adder cell.

1-bit addition with carry-in/carry-out.

adder_4bit

4-bit Ripple Carry Adder.

Implemented by cascading 4 full-adder modules.

comparator

1-bit Comparator.

Generates less, equal, and greater outputs.

comparator_Nbit

N-bit Comparator.

Scalable design for comparing larger data widths.

2. ⚡ Sequential and Control Logic

This section includes more complex circuits using registers and Finite State Machines (FSMs).

Module

Description

Key Features

Register

Generic Data Register.

Parameterized data width, synchronous load (we), and asynchronous output control (oe).

sequential_multiplier

Automatic Sequential Multiplier.

Implements multiplication using a simple FSM and dedicated registers (A, B for operands, C for result).

testbench_sm

Testbench for Multiplier.

Simulates the sequence: WRITE operants, MULTIPLY, and DISPLAY result.

🚀 How to Run Simulations

To test any module (e.g., the 4-bit multiplier), follow these steps:

Clone the Repository:

git clone [your_repo_link]
cd [repo_name]


Compile the Verilog Files:
Use iverilog to compile the core module (.v) and its testbench (_tb.v). Make sure all dependencies (like Register.v and adder.v) are included.

iverilog -o multiplier_sim sequential_multiplier.v Register.v sequential_multiplier_tb.v


Run the Simulation:
This generates the .vcd file (waveform data).

vvp multiplier_sim


(The simulation generates a wave.vcd file based on the test scenarios in the testbench.)

View the Waveforms (GTKWave):
Open the generated file to visually verify the circuit's behavior.

gtkwave wave.vcd


📝 Configuration and Setup

Tools Used: Icarus Verilog (iverilog), vvp, GTKWave.

Time Unit: The simulations are configured with a timescale of 1ns / 1ps.

Data Width: Most generic modules use DATA_WIDTH = 8 by default, but testbenches often use DATA_WIDTH = 4 for easier result verification (e.g., in the multiplier example).

(C) [Your Name / Student Group] | Verilog HDL | Digital Systems
