class bmu_and_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_and_sequence)

function new(string name = "bmu_and_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ==========================================================================================================
    // ==================== Randomized Testing ==================================================================
    // ==========================================================================================================
    
    // Normal AND operations
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal AND operation", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.land = 1;
      finish_item(req);
    end
    
    // Inverted AND operations (A & ~B)
    `uvm_info(get_type_name(), "[Randomized Tests 2] Inverted AND operation", UVM_LOW);
    repeat(10)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      
      req.ap = 0;
      req.ap.land = 1;
      req.ap.zbb = 1;
      
      finish_item(req);
    end

    // ==========================================================================================================
    // ==================== Directed Testing ====================================================================
    // ==========================================================================================================

    // Directed Test 1: AND operation with all bits set to 1
    `uvm_info(get_type_name(), "[Directed Test 1]: AND with all bits set to 1", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'hFFFFFFFF;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
        
    // Directed Test 2: AND operation with all bits set to 0
    `uvm_info(get_type_name(), "[Directed Test 2]: AND with all bits set to 0", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;
    req.b_in = 32'h00000000;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 3: AND operation when one operand is zeros and the other is ones
    `uvm_info(get_type_name(), "[Directed Test 3]: AND with one operand as 0s and the other as 1s", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;  // All bits set to 1
    req.b_in = 32'h00000000;  // All bits set to
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 4: AND with maximum positive and minimum values
    `uvm_info(get_type_name(), "[Directed Test 4]: AND with max positive and min negative values (0x7FFFFFFF & 0x80000000)", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h7FFFFFFF;
    req.b_in = 32'h80000000;
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 5: AND with alternating bits pattern 1
    `uvm_info(get_type_name(), "[Directed Test 5]: AND with alternating bits (0x55555555 & 0xAAAAAAAA)", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h55555555;  // Alternating 01010101...
    req.b_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 6: AND with alternating bits pattern 2
    `uvm_info(get_type_name(), "[Directed Test 6]: AND with alternating bits (0x55555555 & 0x55555555)", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h55555555;  // Alternating 01010101...
    req.b_in = 32'h55555555;  // Alternating 01010101...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 7: AND with alternating bits pattern 3
    `uvm_info(get_type_name(), "[Directed Test 7]: AND with alternating bits (0xAAAAAAAA & 0xAAAAAAAA)", UVM_LOW);
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.b_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);

    // Add idle cycles to ensure all transactions from previous test are completed
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
endclass: bmu_and_sequence