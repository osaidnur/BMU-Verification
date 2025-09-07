class bmu_packu_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_packu_sequence)

function new(string name = "bmu_packu_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");

    // PACKU Operation: Pack the upper 16 bits of both inputs into a 32-bit result
    // Result = {b_in[31:16], a_in[31:16]}
    // Lower 16 bits of both inputs are ignored

    // =================================================================================  
    // ==================== Randomized Testing =========================================
    // =================================================================================
    
    // Normal PACKU operations with random inputs
    `uvm_info(get_type_name(), "[Randomized Tests ] Normal PACKU operation", UVM_LOW);
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.packu = 1;
      finish_item(req);
    end

    // Add idle cycles to ensure all transactions from previous test are completed
    // repeat(1) begin
    //   start_item(req);
    //   req.rst_l = 1;
    //   req.scan_mode = 0;
    //   req.valid_in = 0;  // No valid transaction - idle cycle
    //   req.csr_ren_in = 0;
    //   req.ap = 0;
    //   finish_item(req);
    // end

    // =================================================================================
    // ==================== Directed Testing ===========================================
    // =================================================================================
    
    // Directed Test 1: Both inputs all zeros
    `uvm_info(get_type_name(), "[Directed Test 1] PACKU: Both zeros ", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h00000000;  // All zeros
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: Both inputs all ones
    `uvm_info(get_type_name(), "[Directed Test 2] PACKU: Both all ones ", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'hFFFFFFFF;  // All ones
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: Maximum upper halfwords
    `uvm_info(get_type_name(), "[Directed Test 3] PACKU: Max upper halfwords (0xFFFF0000, 0xFFFF0000) -> 0xFFFFFFFF", UVM_LOW);
    req.a_in = 32'hFFFF0000;  // Max upper 16 bits, lower zeros
    req.b_in = 32'hFFFF0000;  // Max upper 16 bits, lower zeros
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: Minimum non-zero upper halfwords
    `uvm_info(get_type_name(), "[Directed Test 4] PACKU: Min non-zero upper (0x00010000, 0x00010000) -> 0x00010001", UVM_LOW);
    req.a_in = 32'h00010000;  // Minimum non-zero upper 16 bits
    req.b_in = 32'h00010000;  // Minimum non-zero upper 16 bits
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 5: One input zero upper, other max upper
    `uvm_info(get_type_name(), "[Directed Test 5] PACKU: Zero vs max upper 1", UVM_LOW);
    req.a_in = 32'h00008765;  // upper = 0x0000
    req.b_in = 32'hFFFF4321;  // upper = 0xFFFF
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 6: One input max upper, other zero upper
    `uvm_info(get_type_name(), "[Directed Test 6] PACKU: Max vs zero upper 2", UVM_LOW);
    req.a_in = 32'hFFFFDEAD;  // upper = 0xFFFF
    req.b_in = 32'h0000BEEF;  // upper = 0x0000
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 7: lower bits all ones, specific lower bits
    `uvm_info(get_type_name(), "[Directed Test 7] PACKU: Lower half word is ones", UVM_LOW);
    req.a_in = 32'h1234FFFF;  // lower all ones, lower = 0x1234
    req.b_in = 32'h5678FFFF;  // lower all ones, lower = 0x5678
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 8: lower bits all zeros, specific lower bits
    `uvm_info(get_type_name(), "[Directed Test 8] PACKU: Lower half word is zeros", UVM_LOW);
    req.a_in = 32'h12340000;  // lower all zeros, lower = 0x1234
    req.b_in = 32'h56780000;  // lower all zeros, lower = 0x5678
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 9: Mixed lower bits, zero upper bits
    `uvm_info(get_type_name(), "[Directed Test 9] PACKU zero upper half-words", UVM_LOW);
    req.a_in = 32'h00001234;  // Mixed lower, upper = 0x0000
    req.b_in = 32'h00005678;  // Mixed lower, upper = 0x0000
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
        
    // Directed Test 10: Alternating patterns in upper halfwords
    `uvm_info(get_type_name(), "[Directed Test 10] PACKU: Alternating upper patterns ", UVM_LOW);
    req.a_in = 32'h55551234;  // upper = 0x5555 (alternating 01)
    req.b_in = 32'hAAAA6789;  // upper = 0xAAAA (alternating 10)
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 11: Alternating patterns in upper halfwords
    `uvm_info(get_type_name(), "[Directed Test 11] PACKU: Alternating upper patterns ", UVM_LOW);
    req.a_in = 32'h55555555;  // upper = 0x5555 (alternating 01)
    req.b_in = 32'hAAAA0000;  // upper = 0xAAAA (alternating 10)
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);

    
    
    // Directed Test 12: Byte boundaries in upper halfwords
    `uvm_info(get_type_name(), "[Directed Test 12] PACKU: Byte boundaries ", UVM_LOW);
    req.a_in = 32'h00FF1234;  // upper = 0x00FF
    req.b_in = 32'hFF005678;  // upper = 0xFF00
    req.ap = 0;
    req.ap.packu = 1;
    start_item(req);
    finish_item(req);
      
    // Directed Test 13: Nibble patterns
    `uvm_info(get_type_name(), "[Directed Test 13] PACKU: Nibble patterns (0x9876F0F0, 0x54320A0A)", UVM_LOW);
    req.a_in = 32'hF0F09876;  // upper = 0xF0F0
    req.b_in = 32'h0A0A5432;  // upper = 0x0A0A
    req.ap = 0;
    req.ap.packu = 1;
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

endclass: bmu_packu_sequence