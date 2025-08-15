package alu_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // Include sequence item first (foundational type)
  // `include "alu_interface.sv"
  `include "alu_sequence_item.sv"
  
  // Include sequences (they depend on sequence_item)
  `include "../sequences/alu_add_sequence.sv"
  `include "../sequences/alu_sub_sequence.sv"
  `include "../sequences/alu_or_sequence.sv"
  `include "../sequences/alu_xor_sequence.sv"
  `include "../sequences/alu_and_sequence.sv"
  `include "../sequences/alu_overflow_sequence.sv"
  `include "../sequences/alu_underflow_sequence.sv"
  `include "../sequences/alu_random_sequence.sv"
  `include "../sequences/alu_undefined_opcode_sequence.sv"

  // Include components (they depend on sequence_item and sequences)
  `include "alu_sequencer.sv"
  `include "alu_monitor.sv"
  `include "alu_driver.sv"
  `include "alu_agent.sv"
  `include "alu_subscriber.sv"
  `include "alu_scoreboard.sv"
  `include "alu_environment.sv"

  `include "../tests/alu_add_test.sv"
  `include "../tests/alu_and_test.sv"
  `include "../tests/alu_or_test.sv"
  `include "../tests/alu_overflow_test.sv"
  `include "../tests/alu_random_test.sv"
  `include "../tests/alu_regression_test.sv"
  `include "../tests/alu_sub_test.sv"
  `include "../tests/alu_undefined_test.sv"
  `include "../tests/alu_underflow_test.sv"
  `include "../tests/alu_xor_test.sv"

endpackage