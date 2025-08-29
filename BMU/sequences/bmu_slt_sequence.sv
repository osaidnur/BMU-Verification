class bmu_slt_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_slt_sequence)

function new(string name = "bmu_slt_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal SLT operation (signed)", UVM_LOW);
    // Normal SLT operations with random inputs (signed comparison)
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.slt = 1;
      req.ap.unsign = 0;  // Signed comparison
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

    `uvm_info(get_type_name(), "[Randomized Tests 2] Normal SLT operation (unsigned)", UVM_LOW);
    // Normal SLT operations with random inputs (unsigned comparison)
    repeat(15)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.slt = 1;
      req.ap.unsign = 1;  // Unsigned comparison
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

    // ========================================================================
    // ==================== Directed Testing for Signed SLT ===================
    // ========================================================================
    
    // Test 1: Equal values (signed) - should return any of them
    `uvm_info(get_type_name(), "[Directed Test 1] SLT Signed - Equal operands", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h12345678;
    req.b_in = 32'h12345678;  // Equal values
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 2: Positive < Positive (true case)
    `uvm_info(get_type_name(), "[Directed Test 2] SLT Unsigne - Positive comparisons 1", UVM_LOW);
    req.a_in = 32'h00000005;  // 5
    req.b_in = 32'h0000000A;  // 10
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 3: Positive > Positive (false case)
    `uvm_info(get_type_name(), "[Directed Test 3] SLT Signed - Positive comparisons 2", UVM_LOW);
    req.a_in = 32'h0000000A;  // 10
    req.b_in = 32'h00000005;  // 5
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 4: Negative < Negative (true case)
    `uvm_info(get_type_name(), "[Directed Test 4] SLT Signed - Negative comparisons 1", UVM_LOW);
    req.a_in = 32'hFFFFFFF6;  // -10
    req.b_in = 32'hFFFFFFFB;  // -5
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 5: Negative > Negative (false case)
    `uvm_info(get_type_name(), "[Directed Test 5] SLT Signed - Negative comparisons 2", UVM_LOW);
    req.a_in = 32'hFFFFFFFB;  // -5
    req.b_in = 32'hFFFFFFF6;  // -10
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 6: Negative < Positive (true case)
    `uvm_info(get_type_name(), "[Directed Test 6] SLT Signed - Negative vs Positive 1", UVM_LOW);
    req.a_in = 32'hFFFFFFFB;  // -5
    req.b_in = 32'h00000005;  // 5
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 7: Positive < Negative (false case)
    `uvm_info(get_type_name(), "[Directed Test 7] SLT Signed - Negative vs Positive 2", UVM_LOW);
    req.a_in = 32'h00000005;  // 5
    req.b_in = 32'hFFFFFFFB;  // -5
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 8: Zero comparisons (signed)
    `uvm_info(get_type_name(), "[Directed Test 8] SLT Signed - Zero comparisons 1", UVM_LOW);
    req.a_in = 32'h00000000;  // 0
    req.b_in = 32'h00000001;  // 1
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // Test 9: Zero comparisons (signed)
    `uvm_info(get_type_name(), "[Directed Test 9] SLT Signed - Zero comparisons 2", UVM_LOW);
    req.a_in = 32'h00000001;  // 0
    req.b_in = 32'h00000000;  // 1
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);


    // Test 10: Maximum positive vs minimum negative (signed)
    `uvm_info(get_type_name(), "[Directed Test 10] SLT Signed - Max positive vs Min negative", UVM_LOW);
    req.a_in = 32'h7FFFFFFF;  // Max positive (2^31 - 1)
    req.b_in = 32'h80000000;  // Min negative (-2^31)
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);


    // Test 11: All zeros vs all ones (signed)
    `uvm_info(get_type_name(), "[Directed Test 11] all zeros vs. all ones", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros (0)
    req.b_in = 32'hFFFFFFFF;  // All ones (-1 in signed)
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed: 0 < -1 is false
    start_item(req);
    finish_item(req);


    // Test 12: Alternating patterns (signed)
    `uvm_info(get_type_name(), "[Directed Test 12] SLT Signed - Alternating patterns", UVM_LOW);
    req.a_in = 32'h55555555;  // Pattern 1
    req.b_in = 32'hAAAAAAAA;  // Pattern 2 (negative in signed)
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 0;  // Signed
    start_item(req);
    finish_item(req);

    // ==========================================================================
    // ==================== Directed Testing for Unsigned SLT ===================
    // ==========================================================================
    
    // Test 13: Equal values (unsigned) - should return 0
    `uvm_info(get_type_name(), "[Directed Test 13] SLT Unsigned - Equal Operands", UVM_LOW);
    req.a_in = 32'h12345678;
    req.b_in = 32'h12345678;  // Equal values
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;  // Unsigned
    start_item(req);
    finish_item(req);

    // Test 14: Zero vs non-zero (unsigned) 1
    `uvm_info(get_type_name(), "[Directed Test 14] SLT Unsigned - Zero vs Non-zero 1", UVM_LOW);
    req.a_in = 32'h00000000;  // 0
    req.b_in = 32'h00000001;  // 1
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;  // Unsigned
    start_item(req);
    finish_item(req);

    // Test 15: Zero vs non-zero (unsigned) 2
    `uvm_info(get_type_name(), "[Directed Test 15] SLT Unsigned - Zero vs Non-zero 2", UVM_LOW);
    req.a_in = 32'h00000001;  // 0
    req.b_in = 32'h00000000;  // 1
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;  // Unsigned
    start_item(req);
    finish_item(req);
      
    // Test 16: All zeros vs all ones (unsigned)
    `uvm_info(get_type_name(), "[Directed Test 16] SLT Unsigned - All zeros vs All ones", UVM_LOW);
    req.a_in = 32'h00000000;  // All zeros (0)
    req.b_in = 32'hFFFFFFFF;  // All ones (max unsigned)
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;  // Unsigned: 0 < max is true
    start_item(req);
    finish_item(req);

    
    // Test 17: Alternating patterns (unsigned)
    `uvm_info(get_type_name(), "[Directed Test 17] SLT Unsigned - Alternating patterns", UVM_LOW);
    req.a_in = 32'h55555555;  // Pattern 1
    req.b_in = 32'hAAAAAAAA;  // Pattern 2
    req.ap = 0;
    req.ap.slt = 1;
    req.ap.unsign = 1;  // Unsigned
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

endclass: bmu_slt_sequence