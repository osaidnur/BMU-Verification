# UVM Project Structure

This is a UVM (Universal Verification Methodology) project template with a standard directory structure.

## Project Overview

This project demonstrates a typical **UVM verification environment** including:

- **DUT (Device Under Test)** resources and RTL design.
- **Testbench components**: environment, agents, drivers, monitors, sequencers, and scoreboard.
- **Sequences and tests**: modular sequences and reusable tests for the DUT.
- **Simulation scripts**: makefile for running simulations.

This structure ensures **modularity, reusability, and maintainability** for your verification environment.

## Directory Structure

dut_rm/                  # DUT resource files
rtl/                     # RTL source files
sim/
└── makefile             # Simulation run scripts

tb/                      # Testbench top-level
    top_tb.sv            # Top-level testbench file

    env/                 # Environment components
        dut_env.sv
        agent/           # Agent components
            dut_agent.sv
            driver/
                dut_driver.sv
            monitor/
                dut_monitor.sv
            sequencer/
                dut_sequencer.sv
                transaction.sv
        scoreboard/
            dut_scoreboard.sv

    include/             # Include files and definitions
        uvm_def.sv

    interface/           # DUT interface files
        Bit_Manipulation_intf.sv

    packages/            # UVM packages
        dut_test_package.sv

    sequences/           # Test sequences
        and_sequences/
            normal_and_operation_seq.sv

    tests/               # Test files
        dut_base_test.sv
        dut_reg_test.sv