class bmu_clz_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_clz_sequence)

function new(string name = "bmu_clz_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ==========================================================================================================
    // ==================== Randomized Testing ==================================================================
    // ==========================================================================================================

    // Normal CLZ operations with random inputs
    `uvm_info(get_type_name(), "[Randomized Tests 1] CLZ: Normal CLZ operation", UVM_LOW);
    repeat(25)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
      });
      req.ap = 0;
      req.ap.clz = 1;
      finish_item(req);
    end

    // ==========================================================================================================
    // ==================== Directed Testing ====================================================================
    // ==========================================================================================================

    // Test 1: This tests CLZ values from 0 to 31
    `uvm_info(get_type_name(), "[Directed Test 1] CLZ: single bit set at each position", UVM_LOW);
    for(int i = 31; i >= 0; i--) begin
      req.rst_l = 1;
      req.scan_mode = 0;
      req.valid_in = 1;
      req.csr_ren_in = 0;
      req.a_in = 32'h1 << i;  // Single bit set at position i
      req.b_in = 32'h0;       // b_in not used for CLZ
      req.ap = 0;
      req.ap.clz = 1;
      start_item(req);
      finish_item(req);
    end

    // Test 2: All zeros
    `uvm_info(get_type_name(), "[Directed Test 2] CLZ: the input is all zeros", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // All zeros
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.clz = 1;
    start_item(req);
    finish_item(req);
    
    // Test 3: All ones
    `uvm_info(get_type_name(), "[Directed Test 3] CLZ: the input is all ones", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // All ones
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.clz = 1;
    start_item(req);
    finish_item(req);
        
    // Test 4: Alternating pattern starting with 1 - should return 0
    `uvm_info(get_type_name(), "[Directed Test 4] CLZ: Alternating pattern starting with 1", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // 10101010... (starts with 1)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.clz = 1;
    start_item(req);
    finish_item(req);

    // Test 5: Alternating pattern starting with 0 - should return 1
    `uvm_info(get_type_name(), "[Directed Test 5] CLZ: Alternating pattern starting with 0", UVM_LOW);
    req.a_in = 32'h55555555;  // 01010101... (starts with 0)
    req.b_in = 32'h0;
    req.ap = 0;
    req.ap.clz = 1;
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

endclass: bmu_clz_sequence