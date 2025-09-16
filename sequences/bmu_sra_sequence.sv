class bmu_sra_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_sra_sequence)

function new(string name = "bmu_sra_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==========================================================================================================
    // ==================== Randomized Testing ==================================================================
    // ==========================================================================================================

    // Normal SRA operations with random positive inputs
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal SRA operation with positive numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {[32'h00000001:32'h7FFFFFFF]}; // Positive numbers only
          b_in inside {[0:31]};
      });
      req.ap = 0;
      req.ap.sra = 1;
      finish_item(req);
    end

    // Normal SRA operations with random negative inputs
    `uvm_info(get_type_name(), "[Randomized Tests 2] Normal SRA operation with negative numbers", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {[32'h80000000:32'hFFFFFFFE]}; // Negative numbers only
          b_in inside {[0:31]};
      });
      req.ap = 0;
      req.ap.sra = 1;
      finish_item(req);
    end
    
    // ==========================================================================================================
    // ==================== Directed Testing ====================================================================
    // ==========================================================================================================
    
    // Test 1: Shift by 0 bits with positive number (max positive)
    `uvm_info(get_type_name(), "[Directed Test 1] Shift by 0 bits with positive number (0x7FFFFFFF)", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h7FFFFFFF;  // Max positive number
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);
    
    // Test 2: Shift by 0 bits with negative number (min negative)
    `uvm_info(get_type_name(), "[Directed Test 2] Shift by 0 bits with negative number (0x80000000)", UVM_LOW);
    req.a_in = 32'h80000000;  // Min negative number
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);
    
    // Test 3: Shift by 0 bits with positive alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 3] Shift by 0 bits with positive alternating pattern (0x55555555)", UVM_LOW);
    req.a_in = 32'h55555555;  // Positive alternating pattern
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);

    // Test 4: Shift by 0 bits with negative alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 4] Shift by 0 bits with negative alternating pattern (0xAAAAAAAA)", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Negative alternating pattern
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);
    
    // Test 5: Shift by 31 bits with positive number (max positive)
    `uvm_info(get_type_name(), "[Directed Test 5] Shift by 31 bits with positive number (0x7FFFFFFF)", UVM_LOW);
    req.a_in = 32'h7FFFFFFF;  // Max positive number
    req.b_in = 32'h0000001F;  // Shift by 31 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);
    
    // Test 6: Shift by 31 bits with negative number (min negative)
    `uvm_info(get_type_name(), "[Directed Test 6] Shift by 31 bits with negative number (0x80000000)", UVM_LOW);
    req.a_in = 32'h80000000;  // Min negative number
    req.b_in = 32'h0000001F;  // Shift by 31 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);
    
    // Test 7: Shift by 31 bits with positive alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 7] Shift by 31 bits with positive alternating pattern (0x55555555)", UVM_LOW);
    req.a_in = 32'h55555555;  // Positive alternating pattern
    req.b_in = 32'h0000001F;  // Shift by 31 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);

    // Test 8: Shift by 31 bits with negative alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 8] Shift by 31 bits with negative alternating pattern (0xAAAAAAAA)", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Negative alternating pattern
    req.b_in = 32'h0000001F;  // Shift by 31 bits
    req.ap = 0;
    req.ap.sra = 1;
    start_item(req);
    finish_item(req);

    // Test 9: Shift by 31 bits with all ones
    `uvm_info(get_type_name(), "[Directed Test 9] Shift by 31 bits with all ones (0xFFFFFFFF)", UVM_LOW);
    req.a_in = 32'h00FAFA00;  // All ones
    req.b_in = 32'hFFFFFFFF;  // Shift by 31 bits
    req.ap = 0;
    req.ap.sra = 1;
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
endclass: bmu_sra_sequence