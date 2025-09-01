class bmu_gorc_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_gorc_sequence)

function new(string name = "bmu_gorc_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal GORC operation", UVM_LOW);
    // Normal GORC operations with random inputs
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          ($countones(a_in) < 5);
          b_in[4:0] == 5'b00111; // b_in[4:0] must be 7 for valid GORC
      });
      req.ap = 0;
      req.ap.gorc = 1;
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

    `uvm_info(get_type_name(), "[Randomized Tests 2] GORC with single bit patterns", UVM_LOW);
    // GORC operations with single bits set in various bytes
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          b_in[4:0] == 5'b00111; // b_in[4:0] must be 7 for valid GORC
          // At least one byte has only a single bit set
          ($countones(a_in[31:24]) == 1) || ($countones(a_in[23:16]) == 1) || 
          ($countones(a_in[15:8]) == 1) || ($countones(a_in[7:0]) == 1);
      });
      req.ap = 0;
      req.ap.gorc = 1;
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
    
    // Directed Test 1: All bytes zero
    `uvm_info(get_type_name(), "[Directed Test 1] GORC: All bytes zero ", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All bytes zero
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: All bytes all ones
    `uvm_info(get_type_name(), "[Directed Test 2] GORC: All bytes all ones", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All bytes all ones
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: Single bit set in each byte - pattern 1
    `uvm_info(get_type_name(), "[Directed Test 3] GORC: Single bit per byte (0x01010101)", UVM_LOW);
    req.a_in = 32'h01010101;  // Single bit set in each byte
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 4: Single bit set in each byte - pattern 2
    `uvm_info(get_type_name(), "[Directed Test 4] GORC: Single bit per byte (0x04040404)", UVM_LOW);
    req.a_in = 32'h04040404;  // Single bit set in each byte
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 5: Single bit set in each byte - pattern 3
    `uvm_info(get_type_name(), "[Directed Test 5] GORC: Single bit per byte (0x10101010)", UVM_LOW);
    req.a_in = 32'h10101010;  // Single bit set in each byte
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 6: Single bit set in each byte - pattern 4
    `uvm_info(get_type_name(), "[Directed Test 6] GORC: Single bit per byte (0x80808080)", UVM_LOW);
    req.a_in = 32'h80808080;  // Single bit set in each byte
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 7: Only MSB byte non-zero
    `uvm_info(get_type_name(), "[Directed Test 7] GORC: Only MSB byte non-zero (0x10000000)", UVM_LOW);
    req.a_in = 32'h10000000;  // Only byte 3 (MSB) non-zero
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 8: Only byte 2 non-zero
    `uvm_info(get_type_name(), "[Directed Test 8] GORC: Only byte 2 non-zero (0x00300000)", UVM_LOW);
    req.a_in = 32'h00300000;  // Only byte 2 non-zero
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 9: Only byte 3 non-zero
    `uvm_info(get_type_name(), "[Directed Test 9] GORC: Only byte 1 non-zero (0x00005000)", UVM_LOW);
    req.a_in = 32'h00005000;  // Only byte 1 non-zero
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 10: Only LSB byte non-zero
    `uvm_info(get_type_name(), "[Directed Test 10] GORC: Only LSB byte non-zero (0x00000070)", UVM_LOW);
    req.a_in = 32'h00000070;  // Only byte 0 (LSB) non-zero
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);

    // Directed Test 11: Alternating zero and non-zero bytes
    `uvm_info(get_type_name(), "[Directed Test 11] GORC: Alternating bytes Pattern 1", UVM_LOW);
    req.a_in = 32'h10002000;  // Alternating non-zero and zero bytes
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 12: Different alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 12] GORC: Alternating Pattern 2 ", UVM_LOW);
    req.a_in = 32'h00560078;  // Different alternating pattern
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    
    // Directed Test 13: Single bit in different positions
    `uvm_info(get_type_name(), "[Directed Test 13] GORC: different Bit positions (0x08040201)", UVM_LOW);
    req.a_in = 32'h08040201;  // Different single bit positions per byte
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 14: Nibble patterns
    `uvm_info(get_type_name(), "[Directed Test 14] GORC: Nibble patterns (0x0F00F000)", UVM_LOW);
    req.a_in = 32'h0F00F000;  // Nibble patterns in some bytes
    req.b_in = 32'h00000007;  // b_in[4:0] = 7 for valid GORC
    req.ap = 0;
    req.ap.gorc = 1;
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

endclass: bmu_gorc_sequence