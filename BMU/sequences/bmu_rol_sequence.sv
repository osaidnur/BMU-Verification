class bmu_rol_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_rol_sequence)

function new(string name = "bmu_rol_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal ROL operation", UVM_LOW);
    // Normal ROL operations with random inputs
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
      req.ap.rol = 1;
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

    `uvm_info(get_type_name(), "[Randomized Tests 2] ROL operation with specific bit patterns", UVM_LOW);
    // ROL operations with specific bit patterns
    repeat(20)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
          csr_ren_in == 0;
          a_in inside {32'hFFFFFFFF, 32'h55555555, 32'hAAAAAAAA, 32'h12345678, 32'h87654321};
          b_in inside {[0:31]};
      });
      req.ap = 0;
      req.ap.rol = 1;
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
    
    // ==================== Directed Testing for Rotate by 0 bits ===================
    
    // Test 1: Rotate by 0 bits with all 1s
    `uvm_info(get_type_name(), "[Directed Test 1] Rotate by 0 bits with all ones (0xFFFFFFFF)", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'h00000000;  // Rotate by 0 bits
    req.ap = 0;
    req.ap.rol = 1;
    start_item(req);
    finish_item(req);
    
    // Test 2: Rotate by 0 bits with alternating pattern 1
    `uvm_info(get_type_name(), "[Directed Test 2] Rotate by 0 bits with alternating pattern 1 (0x55555555)", UVM_LOW);
    req.a_in = 32'h55555555;
    req.b_in = 32'h00000000;  // Rotate by 0 bits
    req.ap = 0;
    req.ap.rol = 1;
    start_item(req);
    finish_item(req);
    
    // Test 3: Rotate by 0 bits with alternating pattern 2
    `uvm_info(get_type_name(), "[Directed Test 3] Rotate by 0 bits with alternating pattern 2 (0xAAAAAAAA)", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;
    req.b_in = 32'h00000000;  // Rotate by 0 bits
    req.ap = 0;
    req.ap.rol = 1;
    start_item(req);
    finish_item(req);

    // ==================== Directed Testing for Rotate by 31 bits ===================
    
    // Test 4: Rotate by 31 bits with all 1s
    `uvm_info(get_type_name(), "[Directed Test 4] Rotate by 31 bits with all ones (0xFFFFFFFF)", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;
    req.b_in = 32'h0000001F;  // Rotate by 31 bits
    req.ap = 0;
    req.ap.rol = 1;
    start_item(req);
    finish_item(req);

    // Test 5: Rotate by 31 bits with alternating pattern 1
    `uvm_info(get_type_name(), "[Directed Test 5] Rotate by 31 bits with alternating pattern 1 (0x55555555)", UVM_LOW);
    req.a_in = 32'h55555555;
    req.b_in = 32'h0000001F;  // Rotate by 31 bits
    req.ap = 0;
    req.ap.rol = 1;
    start_item(req);
    finish_item(req);
    
    // Test 6: Rotate by 31 bits with alternating pattern 2
    `uvm_info(get_type_name(), "[Directed Test 6] Rotate by 31 bits with alternating pattern 2 (0xAAAAAAAA)", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;
    req.b_in = 32'h0000001F;  // Rotate by 31 bits
    req.ap = 0;
    req.ap.rol = 1;
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

endclass: bmu_rol_sequence