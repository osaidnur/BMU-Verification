class bmu_and_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_and_sequence)

function new(string name = "bmu_and_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // Reset the DUT
    req.rst_l = 0;
    start_item(req);
    `uvm_info(get_type_name(), "Reset the DUT", UVM_NONE);
    finish_item(req);
    
    // ==================== Randomized Testing ===================
    
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal AND operation", UVM_LOW);
    // Normal AND operations
    repeat(10)begin
    
      req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      };
      
      req.ap = 0;
      req.ap.land = 1;
      start_item(req);
      finish_item(req);
    end

    `uvm_info(get_type_name(), "[Randomized Tests 2] Inverted AND operation", UVM_LOW);
    // Inverted AND operations (A & ~B)
    repeat(10)begin
      
      req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      };
      
      req.ap = 0;
      req.ap.land = 1;
      req.ap.zbb = 1;
      start_item(req);
      finish_item(req);
    end

    // ==================== Directed Testing ===================

    // Directed Test 1: AND operation with all bits set to 1
    `uvm_info(get_type_name(), "[Directed Test 1]: AND with all bits set to 1", UVM_LOW);
    // req.rst_l = 1;
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
    // req.rst_l = 1;
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
    // req.rst_l = 1;
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
    // req.rst_l = 1;
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
    // req.rst_l = 1;
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
    // req.rst_l = 1;
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
    // req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.b_in = 32'hAAAAAAAA;  // Alternating 10101010...
    req.ap = 0;
    req.ap.land = 1;
    start_item(req);
    finish_item(req);

    
  
endtask: body

endclass: bmu_and_sequence