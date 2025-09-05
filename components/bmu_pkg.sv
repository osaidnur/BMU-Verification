package bmu_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // Include sequence item first (foundational type)
  // `include "bmu_interface.sv"
  `include "bmu_sequence_item.sv"
  `include "bmu_reference_model.sv"
  
  // Include sequences (they depend on sequence_item)
  `include "../sequences/bmu_reset_sequence.sv"
  `include "../sequences/bmu_csr_write_sequence.sv"
  `include "../sequences/bmu_add_sequence.sv"
  `include "../sequences/bmu_and_sequence.sv"
  `include "../sequences/bmu_bext_sequence.sv"
  `include "../sequences/bmu_clz_sequence.sv"
  `include "../sequences/bmu_cpop_sequence.sv"
  `include "../sequences/bmu_gorc_sequence.sv"
  `include "../sequences/bmu_min_sequence.sv"
  `include "../sequences/bmu_packu_sequence.sv"
  `include "../sequences/bmu_rol_sequence.sv"
  `include "../sequences/bmu_sh3add_sequence.sv"
  `include "../sequences/bmu_siext_h_sequence.sv"
  `include "../sequences/bmu_sll_sequence.sv"
  `include "../sequences/bmu_slt_sequence.sv"
  `include "../sequences/bmu_sra_sequence.sv"
  `include "../sequences/bmu_xor_sequence.sv"
  `include "../sequences/bmu_errors_sequence.sv"
  `include "../sequences/bmu_valid_in_sequence.sv"


  // Include components (they depend on sequence_item and sequences)
  `include "bmu_sequencer.sv"
  `include "bmu_driver.sv"
  `include "bmu_monitor.sv"
  `include "bmu_agent.sv"
  `include "bmu_subscriber.sv"
  `include "bmu_scoreboard.sv"
  `include "bmu_environment.sv"

  // Include tests (they depend on environment and sequences)
  `include "../tests/bmu_csr_write_test.sv"
  `include "../tests/bmu_add_test.sv"
  `include "../tests/bmu_and_test.sv"
  `include "../tests/bmu_bext_test.sv"
  `include "../tests/bmu_clz_test.sv"
  `include "../tests/bmu_cpop_test.sv"
  `include "../tests/bmu_gorc_test.sv"
  `include "../tests/bmu_min_test.sv"
  `include "../tests/bmu_packu_test.sv"
  `include "../tests/bmu_regression_test.sv"
  `include "../tests/bmu_rol_test.sv"
  `include "../tests/bmu_sh3add_test.sv"
  `include "../tests/bmu_siext_h_test.sv"
  `include "../tests/bmu_sll_test.sv"
  `include "../tests/bmu_slt_test.sv"
  `include "../tests/bmu_sra_test.sv"
  `include "../tests/bmu_xor_test.sv"
  `include "../tests/bmu_errors_test.sv"
  `include "../tests/bmu_valid_in_test.sv"

  
endpackage