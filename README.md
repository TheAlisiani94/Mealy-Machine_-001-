# Mealy Machine Sequence Detector (001) in Verilog

This project implements a Mealy Machine in Verilog that detects the sequence "001" in a serial input stream. The machine sets the output `det` to 1 when the sequence "001" is detected (i.e., after seeing two consecutive zeros followed by a one). A testbench is included to verify the machine’s functionality across various input sequences, including correct detections, incorrect sequences, and overlapping patterns.

## Project Overview

The Mealy Machine is a finite state machine (FSM) where the output depends on both the current state and the input (unlike a Moore Machine, where the output depends only on the state). This design uses three states to detect the sequence "001":
- `s0`: Initial state (no zeros seen).
- `s1`: One zero seen.
- `s2`: Two zeros seen (waiting for a 1 to complete the sequence).

When the machine is in state `s2` and the input is 1, it sets `det` to 1, indicating the sequence "001" has been detected, and transitions back to `s0`. The machine is synchronous, with state transitions occurring on the rising edge of the clock, and includes a synchronous reset to return to `s0`.

### Files in the Project

- **`seq_001.sv`**: The main Verilog module implementing the Mealy Machine. It defines the state machine logic for detecting the sequence "001".

- **`seq_001_tb.sv`**: The testbench for the Mealy Machine. It tests various input sequences to verify correct detection, non-detection, overlapping sequences, and reset behavior.

- **`README.md`**: This file, providing documentation and instructions for the project.
