class bmu_add_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_add_sequence)

function new(string name = "bmu_add_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ==========================================================================================================
    // ==================== Randomized Testing ==================================================================
    // ==========================================================================================================
    
    // Normal ADD operations with random inputs
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal ADD operation", UVM_LOW);
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.add = 1;
      finish_item(req);
    end

    // ADD operations with positive numbers to avoid overflow
    `uvm_info(get_type_name(), "[Randomized Tests 2] ADD operation with positive numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {[32'h00000000:32'h3FFFFFFF]}; // Positive numbers
          b_in inside {[32'h00000000:32'h3FFFFFFF]}; // Positive numbers
      });
      req.ap = 0;
      req.ap.add = 1;
      finish_item(req);
    end

    // ADD operations with negative numbers to avoid overflow
    `uvm_info(get_type_name(), "[Randomized Tests 3] ADD operation with negative numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {[32'h80000000:32'hFFFFFFFF]}; // Negative numbers
          b_in inside {[32'h80000000:32'hFFFFFFFF]}; // Negative numbers
      });
      req.ap = 0;
      req.ap.add = 1;
      finish_item(req);
    end
    
    // ==========================================================================================================
    // ==================== Directed Testing  ===================================================================
    // ==========================================================================================================
    
    // Test 1: All zeros in both operands
    `uvm_info(get_type_name(), "[Directed Test 1] ADD: All zeros - 0 + 0 = 0", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 2: All ones in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 2] ADD: All ones in a_in - 0xFFFFFFFF + 0", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 3: Zeros in a_in, all ones in b_in
    `uvm_info(get_type_name(), "[Directed Test 3] ADD: All ones in b_in - 0 + 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'hFFFFFFFF;  // All ones
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 4: All ones in both operands (overflow case)
    `uvm_info(get_type_name(), "[Directed Test 4] ADD: All ones in both (overflow) - 0xFFFFFFFF + 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'hFFFFFFFF;  // All ones
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 5: Alternating pattern 1 in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 5] ADD: Alternating pattern 1 in a_in - 0x55555555 + 0", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 6: Zeros in a_in, alternating pattern 1 in b_in
    `uvm_info(get_type_name(), "[Directed Test 6] ADD: Alternating pattern 1 in b_in - 0 + 0x55555555", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 7: Alternating pattern 1 in both operands
    `uvm_info(get_type_name(), "[Directed Test 7] ADD: Alternating pattern 1 in both - 0x55555555 + 0x55555555", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.b_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 8: Alternating pattern 2 in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 8] ADD: Alternating pattern 2 in a_in - 0xAAAAAAAA + 0", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 9: Zeros in a_in, alternating pattern 2 in b_in
    `uvm_info(get_type_name(), "[Directed Test 9] ADD: Alternating pattern 2 in b_in - 0 + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 10: Alternating pattern 2 in both operands
    `uvm_info(get_type_name(), "[Directed Test 10] ADD: Alternating pattern 2 in both - 0xAAAAAAAA + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 11: Mixed alternating patterns
    `uvm_info(get_type_name(), "[Directed Test 11] ADD: Mixed alternating patterns - 0x55555555 + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern 1
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern 2
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 12: Mixed alternating patterns (reversed)
    `uvm_info(get_type_name(), "[Directed Test 12] ADD: Mixed alternating patterns reversed - 0xAAAAAAAA + 0x55555555", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern 2
    req.b_in = 32'h55555555;  // Alternating pattern 1
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // ==================== Directed Testing ===================

    // Test 13: Maximum positive + 1 (overflow to negative)
    `uvm_info(get_type_name(), "[Directed Test 13] Maximum positive + 1 ", UVM_LOW);
    req.a_in = 32'h7FFFFFFF;  // Maximum positive (2^31 - 1)
    req.b_in = 32'h00000001;  // +1
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);
    
    // Test 14: Minimum negative + (-1) (underflow)
    `uvm_info(get_type_name(), "[Directed Test 14] Minimum negative + (-1) ", UVM_LOW);
    req.a_in = 32'h80000000;  // Minimum negative (-2^31)
    req.b_in = 32'hFFFFFFFF;  // -1
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 15: Two's complement edge case
    `uvm_info(get_type_name(), "[Directed Test 15] Two's complement edge case - (-2^31) + (-2^31)", UVM_LOW);
    req.a_in = 32'h80000000;  // -2^31
    req.b_in = 32'h80000000;  // -2^31
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 16: Adding inverse (should result in all 1s)
    `uvm_info(get_type_name(), "[Directed Test 16] Adding inverse - 0x12345678 + 0xEDCBA987", UVM_LOW);
    req.a_in = 32'h12345678;  // Test pattern
    req.b_in = 32'hEDCBA987;  // Bitwise inverse
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Test 17: Maximum positive in B operand (for coverage completeness)
    `uvm_info(get_type_name(), "[Directed Test 17] Maximum positive in B - 0 + 0x7FFFFFFF", UVM_LOW);
    req.a_in = 32'h00000000;  // Zero
    req.b_in = 32'h7FFFFFFF;  // Maximum positive (2^31 - 1)
    req.ap = 0;
    req.ap.add = 1;
    start_item(req);
    finish_item(req);

    // Add idle cycles to ensure all transactions are completed
    repeat(2) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    
endtask: body

endclass: bmu_add_sequence