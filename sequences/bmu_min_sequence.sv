class bmu_min_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_min_sequence)

function new(string name = "bmu_min_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ==================================================================================
    // ==================== Randomized Testing ==========================================
    // ==================================================================================

    // Normal MIN operations with random inputs
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal MIN operation", UVM_LOW);
    repeat(15)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.min = 1;
      req.ap.sub = 1;  // MIN requires SUB to be active
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

    // MIN operations with one negative number
    `uvm_info(get_type_name(), "[Randomized Tests 2] MIN operation with positive and negative numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          ((a_in[31] == 1) && (b_in[31] == 0))  || ((a_in[31] == 0) && (b_in[31] == 1)); // only one of them is negative
      });
      req.ap = 0;
      req.ap.min = 1;
      req.ap.sub = 1;  // MIN requires SUB to be active
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

    `uvm_info(get_type_name(), "[Randomized Tests 3] MIN operation with both positive numbers", UVM_LOW);
    // MIN operations with both positive numbers
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in[31] == 0; // Both positive
          b_in[31] == 0;
      });
      req.ap = 0;
      req.ap.min = 1;
      req.ap.sub = 1;  // MIN requires SUB to be active
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
    
    // Min operations with both negative numbers
    `uvm_info(get_type_name(), "[Randomized Tests 4] MIN operation with both negative numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in[31] == 1; // Both negative
          b_in[31] == 1;
      });
      req.ap = 0;
      req.ap.min = 1;
      req.ap.sub = 1;  // MIN requires SUB to be active
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

    // ====================================================================================
    // ==================== Directed Testing ==============================================
    // ====================================================================================
    
    // Directed Test 1: Both inputs are zero
    `uvm_info(get_type_name(), "[Directed Test 1] MIN: Both zeros ", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // Zero
    req.b_in = 32'h00000000;  // Zero
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: Both inputs are ones
    `uvm_info(get_type_name(), "[Directed Test 2] MIN: Both ones ", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // Ones (-1)
    req.b_in = 32'hFFFFFFFF;  // Ones (-1)
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);

    // Directed Test 3: All ones vs all zeros
    `uvm_info(get_type_name(), "[Directed Test 3] MIN: All ones vs all zeros (0xFFFFFFFF, 0x00000000) -> 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones (-1)
    req.b_in = 32'h00000000;  // All zeros (0)
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);

    // Directed Test 4: One input is zero, other positive
    `uvm_info(get_type_name(), "[Directed Test 4] MIN: Zero vs positive ", UVM_LOW);
    req.a_in = 32'h00000000;  // Zero
    req.b_in = 32'h12345678;  // Positive
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 5: One input is zero, other negative
    `uvm_info(get_type_name(), "[Directed Test 5] MIN: Zero vs negative", UVM_LOW);
    req.a_in = 32'h00000000;  // Zero
    req.b_in = 32'h87654321;  // Negative
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);

    // Directed Test 6: One input is ones , other positive
    `uvm_info(get_type_name(), "[Directed Test 6] MIN: Ones vs positive", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // Ones (-1)  
    req.b_in = 32'h12345678;  // Positive
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);

    // Directed Test 7: One input is ones , other negative
    `uvm_info(get_type_name(), "[Directed Test 7] MIN: Ones vs negative", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // Ones (-1)
    req.b_in = 32'h87654321;  // Negative
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 8: Maximum positive vs minimum negative
    `uvm_info(get_type_name(), "[Directed Test 8] MIN: Max positive vs min negative", UVM_LOW);
    req.a_in = 32'h7FFFFFFF;  // Maximum positive (2147483647)
    req.b_in = 32'h80000000;  // Minimum negative (-2147483648)
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 9: Identical positive values
    `uvm_info(get_type_name(), "[Directed Test 9] MIN: Identical positive operands", UVM_LOW);
    req.a_in = 32'h12345678;  // Positive value
    req.b_in = 32'h12345678;  // Same positive value
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 10: Identical negative values
    `uvm_info(get_type_name(), "[Directed Test 10] MIN: Identical negative operands", UVM_LOW);
    req.a_in = 32'hABCDEF01;  // Negative value
    req.b_in = 32'hABCDEF01;  // Same negative value
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 11: Maximum positive identical
    `uvm_info(get_type_name(), "[Directed Test 11] MIN: Max positive identical", UVM_LOW);
    req.a_in = 32'h7FFFFFFF;  // Max positive
    req.b_in = 32'h7FFFFFFF;  // Max positive
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 12: Minimum negative identical
    `uvm_info(get_type_name(), "[Directed Test 12] MIN: Min negative identical", UVM_LOW);
    req.a_in = 32'h80000000;  // Min negative
    req.b_in = 32'h80000000;  // Min negative
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 13: Close positive values (a < b)
    `uvm_info(get_type_name(), "[Directed Test 13] MIN: Close positive numbers", UVM_LOW);
    req.a_in = 32'h12345678;  // Smaller positive
    req.b_in = 32'h12345679;  // Larger positive
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
    
    // Directed Test 13: Close negative values (a < b)
    `uvm_info(get_type_name(), "[Directed Test 13] MIN: Close negative numbers", UVM_LOW);
    req.a_in = 32'h80000001;  // More negative (smaller)
    req.b_in = 32'h80000002;  // Less negative (larger)
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
    start_item(req);
    finish_item(req);
        
    // Directed Test 14: Alternating patterns
    `uvm_info(get_type_name(), "[Directed Test 14] MIN: Alternating patterns", UVM_LOW);
    req.a_in = 32'h55555555;  // Alternating 01 (positive)
    req.b_in = 32'hAAAAAAAA;  // Alternating 10 (negative)
    req.ap = 0;
    req.ap.min = 1;
    req.ap.sub = 1;  // MIN requires SUB to be active
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

endclass: bmu_min_sequence