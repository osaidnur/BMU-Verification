class bmu_sll_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_sll_sequence)

function new(string name = "bmu_sll_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal SLL operation", UVM_LOW);
    // Normal SLL operations with random inputs (shift by 1 to 30 bits)
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          b_in inside {[0:31]};
      });
      req.ap = 0;
      req.ap.sll = 1;
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


    `uvm_info(get_type_name(), "[Randomized Tests 2] Abnormal SLL operation with different amount of shift", UVM_LOW);
    // Normal SLL operations with random inputs (shift by 1 to 30 bits)
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {32'hFFFFFFFF, 32'h55555555, 32'hAAAAAAAA};
          b_in inside {[0:31]};
      });
      req.ap = 0;
      req.ap.sll = 1;
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
    
    // ==================== Directed Testing for Shift by 0 bits ===================
    
    // Test 1: Shift by 0 bits with all 1s
    `uvm_info(get_type_name(), "[Directed Test 1] Shift by 0 bits with a_in all ones", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);
    
    // Test 2: Shift by 0 bits with alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 2] Shift by 0 bits with a_in alternating pattern 1", UVM_LOW);
     // req.rst_l = 1;
    req.a_in = 32'h55555555;
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);
    
    // Test 3: Shift by 0 bits with another alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 3] Shift by 0 bits with a_in alternating pattern 2", UVM_LOW);
     // req.rst_l = 1;
    req.a_in = 32'hAAAAAAAA;
    req.b_in = 32'h00000000;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);

    // Test 4: Shift by 31 bits with all 1s
    `uvm_info(get_type_name(), "[Directed Test 4] Shift by 31 bits with a_in all ones", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'h0000001F;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);
    
    // Test 5: Shift by 31 bits with alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 5] Shift by 31 bits with a_in alternating pattern 1", UVM_LOW);
     // req.rst_l = 1;
    req.a_in = 32'h55555555;
    req.b_in = 32'h0000001F;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);
    
    // Test 6: Shift by 31 bits with another alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 6] Shift by 31 bits with a_in alternating pattern 2", UVM_LOW);
     // req.rst_l = 1;
    req.a_in = 32'hAAAAAAAA;
    req.b_in = 32'h0000001F;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);


    // Test 7: Shift by 31 bits with another alternating pattern
    `uvm_info(get_type_name(), "[Directed Test 7] Shift by 31 bits with b_in all ones", UVM_LOW);
     // req.rst_l = 1;
    req.a_in = 32'hAAAAAAAA;
    req.b_in = 32'hFFFFFFFF;  // Shift by 0 bits
    req.ap = 0;
    req.ap.sll = 1;
    start_item(req);
    finish_item(req);
        
  
    // ==================== Directed Testing for Shift by 1-31 bits ===================
    //`uvm_info(get_type_name(), "[Directed Test] Shift by 1-31 bits with test pattern", UVM_LOW);
    
    // Test shifting by each amount from 1 to 31 bits with a test pattern
    // for(int i = 1; i <= 31; i++) begin
    //   req.a_in = 32'h12345678;  // Test pattern
    //   req.b_in = i;  // Shift by i bits
    //   req.ap = 0;
    //   req.ap.sll = 1;
    //   start_item(req);
    //   finish_item(req);
    // end
 

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

endclass: bmu_sll_sequence