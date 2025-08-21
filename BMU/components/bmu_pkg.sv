package bmu_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // Include sequence item first (foundational type)
  // `include "bmu_interface.sv"
  `include "bmu_sequence_item.sv"
  
  // Include sequences (they depend on sequence_item)
  // `include "../sequences/bmu_add_sequence.sv"
  // `include "../sequences/bmu_sub_sequence.sv"
  // `include "../sequences/bmu_or_sequence.sv"
  // `include "../sequences/bmu_xor_sequence.sv"
  // `include "../sequences/bmu_and_sequence.sv"
  // `include "../sequences/bmu_overflow_sequence.sv"
  // `include "../sequences/bmu_underflow_sequence.sv"
  // `include "../sequences/bmu_random_sequence.sv"
  // `include "../sequences/bmu_undefined_opcode_sequence.sv"

  // Include components (they depend on sequence_item and sequences)
  `include "bmu_sequencer.sv"
  `include "bmu_monitor.sv"
  `include "bmu_driver.sv"
  `include "bmu_agent.sv"
  `include "bmu_subscriber.sv"
  `include "bmu_scoreboard.sv"
  `include "bmu_environment.sv"

  // `include "../tests/bmu_add_test.sv"
  // `include "../tests/bmu_and_test.sv"
  // `include "../tests/bmu_or_test.sv"
  // `include "../tests/bmu_overflow_test.sv"
  // `include "../tests/bmu_random_test.sv"
  // `include "../tests/bmu_regression_test.sv"
  // `include "../tests/bmu_sub_test.sv"
  // `include "../tests/bmu_undefined_test.sv"
  // `include "../tests/bmu_underflow_test.sv"
  // `include "../tests/bmu_xor_test.sv"

endpackage