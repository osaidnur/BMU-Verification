class bmu_sh3add_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_sh3add_sequence)

function new(string name = "bmu_sh3add_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal SH3ADD operation", UVM_LOW);
    // Normal SH3ADD operations with random inputs
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.sh3add = 1;
      finish_item(req);
    end

    // Add idle cycles to ensure all transactions from previous test are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end

    `uvm_info(get_type_name(), "[Randomized Tests 2] SH3ADD operation with constrained inputs to avoid overflow", UVM_LOW);
    // SH3ADD operations with smaller values to avoid overflow
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {[32'h00000000:32'h1FFFFFFF]}; // Limit a to avoid overflow when shifted
          b_in inside {[32'h00000000:32'h7FFFFFFF]}; // Limit b to positive values
      });
      req.ap = 0;
      req.ap.sh3add = 1;
      finish_item(req);
    end
    
    // Add idle cycles to ensure all transactions from previous test are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    
    // ==================== Directed Testing for Key Bit Patterns ===================
    
    // Test 1: All zeros in both operands
    `uvm_info(get_type_name(), "[Directed Test 1] SH3ADD: All zeros - (0 << 3) + 0 = 0", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 2: All ones in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 2] SH3ADD: All ones in a_in - (0xFFFFFFFF << 3) + 0", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 3: Zeros in a_in, all ones in b_in
    `uvm_info(get_type_name(), "[Directed Test 3] SH3ADD: All ones in b_in - (0 << 3) + 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'hFFFFFFFF;  // All ones
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 4: All ones in both operands
    `uvm_info(get_type_name(), "[Directed Test 4] SH3ADD: All ones in both - (0xFFFFFFFF << 3) + 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'hFFFFFFFF;  // All ones
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 5: Alternating pattern 1 in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 5] SH3ADD: Alternating pattern 1 in a_in - (0x55555555 << 3) + 0", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 6: Zeros in a_in, alternating pattern 1 in b_in
    `uvm_info(get_type_name(), "[Directed Test 6] SH3ADD: Alternating pattern 1 in b_in - (0 << 3) + 0x55555555", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 7: Alternating pattern 1 in both operands
    `uvm_info(get_type_name(), "[Directed Test 7] SH3ADD: Alternating pattern 1 in both - (0x55555555 << 3) + 0x55555555", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.b_in = 32'h55555555;  // Alternating pattern (01010101...)
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 8: Alternating pattern 2 in a_in, zeros in b_in
    `uvm_info(get_type_name(), "[Directed Test 8] SH3ADD: Alternating pattern 2 in a_in - (0xAAAAAAAA << 3) + 0", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 9: Zeros in a_in, alternating pattern 2 in b_in
    `uvm_info(get_type_name(), "[Directed Test 9] SH3ADD: Alternating pattern 2 in b_in - (0 << 3) + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 10: Alternating pattern 2 in both operands
    `uvm_info(get_type_name(), "[Directed Test 10] SH3ADD: Alternating pattern 2 in both - (0xAAAAAAAA << 3) + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern (10101010...)
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 11: Mixed alternating patterns
    `uvm_info(get_type_name(), "[Directed Test 11] SH3ADD: Mixed alternating patterns - (0x55555555 << 3) + 0xAAAAAAAA", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating pattern 1
    req.b_in = 32'hAAAAAAAA;  // Alternating pattern 2
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

        // Test 12: Mixed alternating patterns (reversed)
    `uvm_info(get_type_name(), "[Directed Test 12] SH3ADD: Mixed alternating patterns reversed - (0xAAAAAAAA << 3) + 0x55555555", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating pattern 2
    req.b_in = 32'h55555555;  // Alternating pattern 1
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Add idle cycles to ensure all transactions are completed
    // repeat(1) begin
    //   start_item(req);
    //   req.rst_l = 1;
    //   req.scan_mode = 0;
    //   req.valid_in = 0;  // No valid transaction - idle cycle
    //   req.csr_ren_in = 0;
    //   req.ap = 0;
    //   finish_item(req);
    // end

    // Test 13: Zero first operand - (0 << 3) + 42 = 42
    `uvm_info(get_type_name(), "[Directed Test 13] SH3ADD: (0 << 3) + 42 = 42", UVM_LOW);
    req.a_in = 32'h00000000;  // a = 0
    req.b_in = 32'h0000002A;  // b = 42
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 14: Zero second operand - (5 << 3) + 0 = 40
    `uvm_info(get_type_name(), "[Directed Test 14] SH3ADD: (5 << 3) + 0 = 40", UVM_LOW);
    req.a_in = 32'h00000005;  // a = 5
    req.b_in = 32'h00000000;  // b = 0
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // ==================== Directed Testing for Overflow Scenarios ===================
    
    // Test 10: Intentional overflow case 1
    `uvm_info(get_type_name(), "[Directed Test 15] Overflow Case 1", UVM_LOW);
    req.a_in = 32'h20000000;  // Large value that will overflow when shifted
    req.b_in = 32'h00000001;  // Small addition
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);
    
    // Test 11: Intentional overflow case 2
    `uvm_info(get_type_name(), "[Directed Test 16] Overflow Case 2", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // Max value
    req.b_in = 32'h00000001;  // Small addition
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Test 12: Large operands addition
    `uvm_info(get_type_name(), "[Directed Test 17] Overflow Case 3", UVM_LOW);
    req.a_in = 32'h10000000;
    req.b_in = 32'h7FFFFFFF;  
    req.ap = 0;
    req.ap.sh3add = 1;
    start_item(req);
    finish_item(req);

    // Add idle cycles to ensure all transactions are completed
    repeat(1) begin
      start_item(req);
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 0;  // No valid transaction - idle cycle
      req.csr_ren_in = 0;
      req.ap = 0;
      finish_item(req);
    end
    
endtask: body

endclass: bmu_sh3add_sequence