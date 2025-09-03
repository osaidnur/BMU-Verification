class bmu_siext_h_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_siext_h_sequence)

function new(string name = "bmu_siext_h_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");

    // ==================================================================
    // ==================== Randomized Testing ==========================
    // ==================================================================

    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal SIEXT_H operation", UVM_LOW);
    // Normal SIEXT_H operations with random inputs
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.siext_h = 1;
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

    `uvm_info(get_type_name(), "[Randomized Tests 2] SIEXT_H operation with positive halfwords", UVM_LOW);
    // SIEXT_H operations with positive halfwords (bit 15 = 0)
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in[15] == 0; // Ensure positive halfword
      });
      req.ap = 0;
      req.ap.siext_h = 1;
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

    `uvm_info(get_type_name(), "[Randomized Tests 3] SIEXT_H operation with negative halfwords", UVM_LOW);
    // SIEXT_H operations with negative halfwords (bit 15 = 1)
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in[15] == 1; // Ensure negative halfword
      });
      req.ap = 0;
      req.ap.siext_h = 1;
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
    // ==================== Directed Testing ==================================
    // ========================================================================

    // Directed Test 1: All zeros -
    `uvm_info(get_type_name(), "[Directed Test 1] SIEXT_H: All zeros (0x00000000)", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h0;         // b_in not used for SIEXT_H
    req.ap = 0;
    req.ap.siext_h = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: All ones 
    `uvm_info(get_type_name(), "[Directed Test 2] SIEXT_H: All ones (0xFFFFFFFF)", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.siext_h = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: Maximum positive halfword 
    `uvm_info(get_type_name(), "[Directed Test 3] SIEXT_H: Max positive halfword (0x00007FFF)", UVM_LOW);
    req.a_in = 32'h00007FFF;  // Max positive 16-bit value
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.siext_h = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: Minimum negative halfword 
    `uvm_info(get_type_name(), "[Directed Test 4] SIEXT_H: Min negative halfword (0x00008000) ", UVM_LOW);
    req.a_in = 32'h00008000;  // Min negative 16-bit value
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.siext_h = 1;
    start_item(req);
    finish_item(req);


    // ==================== Directed Testing for Specific Patterns ===================
    
    // Directed Test 5: Alternating pattern in lower 16 bits (positive)
    `uvm_info(get_type_name(), "[Directed Test 5] SIEXT_H: Alternating positive pattern (0x12345555) ", UVM_LOW);
    req.a_in = 32'h12345555;  // Lower 16 bits = 0x5555 (positive)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.siext_h = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 6: Alternating pattern in lower 16 bits (negative)
    `uvm_info(get_type_name(), "[Directed Test 6] SIEXT_H: Alternating negative pattern (0x6789AAAA) ", UVM_LOW);
    req.a_in = 32'h6789AAAA;  // Lower 16 bits = 0xAAAA (negative)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.siext_h = 1;
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

endclass: bmu_siext_h_sequence