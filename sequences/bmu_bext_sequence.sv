class bmu_bext_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_bext_sequence)

function new(string name = "bmu_bext_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ===========================================================================================================
    // ==================== Randomized Testing ===================================================================
    // ===========================================================================================================
    
    // Normal BEXT operations with random inputs
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal BEXT operation", UVM_LOW);
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          b_in inside {[0:31]}; // Bit position 0-31
      });
      req.ap = 0;
      req.ap.bext = 1;
      finish_item(req);
    end

    // BEXT operations with specific bit patterns
    `uvm_info(get_type_name(), "[Randomized Tests 2] BEXT operation with specific bit patterns", UVM_LOW);
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {32'hFFFFFFFF, 32'h55555555, 32'hAAAAAAAA, 32'h12345678, 32'h87654321};
          b_in inside {[0:31]}; // Bit position 0-31
      });
      req.ap = 0;
      req.ap.bext = 1;
      finish_item(req);
    end
    
    // ============================================================================================================
    // ==================== Directed Testing ======================================================================
    // ============================================================================================================
    
    // Test bit extraction for each bit position using test pattern 0x12345678
    `uvm_info(get_type_name(), "[Directed Tests 1] Bit extraction for each bit position (0-31) with test pattern 0x12345678", UVM_LOW);
    
    for(int i = 0; i <= 31; i++) begin
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 1;
      req.csr_ren_in = 0;
      req.a_in = 32'h12345678;  // Test pattern
      req.b_in = i;             // Extract bit at position i
      req.ap = 0;
      req.ap.bext = 1;
      start_item(req);
      finish_item(req);
    end

    // Directed Test 2: Extract from all zeros
    `uvm_info(get_type_name(), "[Directed Test 2] Extract from all zeros", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h0000000F;  // Extract bit 15
    req.ap = 0;
    req.ap.bext = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: Extract from all ones
   `uvm_info(get_type_name(), "[Directed Test 3] Extract from all ones", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h0000000F;  // Extract bit 15
    req.ap = 0;
    req.ap.bext = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: Single bit set at LSB
    `uvm_info(get_type_name(), "[Directed Test 4] Extract Single bit set at LSB ", UVM_LOW);
    req.a_in = 32'h00000001;  // Only LSB set
    req.b_in = 32'h00000000;  // Extract bit 0
    req.ap = 0;
    req.ap.bext = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 5: Single bit set at MSB
    `uvm_info(get_type_name(), "[Directed Test 5] Extract Single bit set at MSB ", UVM_LOW);
    req.a_in = 32'h80000000;  // Only MSB set
    req.b_in = 32'h0000001F;  // Extract bit 31
    req.ap = 0;
    req.ap.bext = 1;
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

endclass: bmu_bext_sequence