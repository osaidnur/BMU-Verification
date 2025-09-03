class bmu_cpop_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_cpop_sequence)

function new(string name = "bmu_cpop_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests] Normal CPOP operation", UVM_LOW);
    // Normal CPOP operations with random inputs
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.cpop = 1;
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
    
    // ==================== Directed Testing for Edge Cases ===================
    
    // Directed Test 1: All zeros - should return 0
    `uvm_info(get_type_name(), "[Directed Test 1] CPOP: All zeros", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h0;         // b_in not used for CPOP
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: All ones - should return 32
    `uvm_info(get_type_name(), "[Directed Test 2] CPOP: All ones ", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: Single bit set (LSB) - should return 1
    `uvm_info(get_type_name(), "[Directed Test 3] CPOP: Single LSB set ", UVM_LOW);
    req.a_in = 32'h00000001;  // Only LSB set
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: Single bit set (MSB) - should return 1
    `uvm_info(get_type_name(), "[Directed Test 4] CPOP: Single MSB set ", UVM_LOW);
    req.a_in = 32'h80000000;  // Only MSB set
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 5: Alternating pattern 1 - should return 16
    `uvm_info(get_type_name(), "[Directed Test 5] CPOP: Alternating pattern 1 (0x55555555) ", UVM_LOW);
    req.a_in = 32'h55555555;  // 01010101... (16 ones)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 6: Alternating pattern 2 - should return 16
    `uvm_info(get_type_name(), "[Directed Test 6] CPOP: Alternating pattern 2 (0xAAAAAAAA)", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // 10101010... (16 ones)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 7: Nibble patterns - should return 16
    `uvm_info(get_type_name(), "[Directed Test 7] CPOP: Nibble pattern (0xF0F0F0F0)", UVM_LOW);
    req.a_in = 32'hF0F0F0F0;  // Alternating nibbles
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 8: Sparse pattern - should return 4
    `uvm_info(get_type_name(), "[Directed Test 8] CPOP: Sparse pattern (0x11111111) ", UVM_LOW);
    req.a_in = 32'h11111111;  // One bit per nibble
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.cpop = 1;
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

endclass: bmu_cpop_sequence