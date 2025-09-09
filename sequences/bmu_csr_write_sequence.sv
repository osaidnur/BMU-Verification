class bmu_csr_write_sequence extends uvm_sequence #(bmu_sequence_item);
`uvm_object_utils(bmu_csr_write_sequence)

function new(string name = "bmu_csr_write_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
      
    // ==================== Randomized Testing ===================
    `uvm_info(get_type_name(), "[Randomized Tests 1] Normal CSR Read operation", UVM_LOW);
    // Normal CSR Read operations with random inputs
    repeat(15)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
      });
      req.ap = 0;
      req.csr_ren_in = 1;
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
    
    `uvm_info(get_type_name(), "[Randomized Tests 2] CSR Write operation with csr_imm=1", UVM_LOW);
    // Normal CSR Write operations with random inputs
    repeat(15)begin
      start_item(req);
      void'(req.randomize() with {
          rst_l == 1;
          scan_mode == 0;
          valid_in == 1;
      });
      req.ap = 0;
      req.csr_ren_in = 0;
      req.ap.csr_write = 1;
      req.ap.csr_imm = 1;
      finish_item(req);
    end


    `uvm_info(get_type_name(), "[Randomized Tests 3] CSR Write operation with csr_imm=0", UVM_LOW);
    // Normal CSR Write operations with random inputs
    repeat(15)begin
        start_item(req);
        void'(req.randomize() with {
            rst_l == 1;
            scan_mode == 0;
            valid_in == 1;
        });
        req.ap = 0;
        req.csr_ren_in = 0;
        req.ap.csr_write = 1;
        finish_item(req);
    end



    // ==================== Directed Testing for Edge Cases ===================
    
    // Directed Test 1: Write to CSR with minimum value
    `uvm_info(get_type_name(), "[Directed Test 1] CSR Write: Minimum value", UVM_LOW);
    req.rst_l = 1;
    req.scan_mode = 0;
    req.valid_in = 1;
    req.csr_ren_in = 0;
    req.a_in = 32'h00000000;  // Minimum value
    req.b_in = 32'h12345678;  // Value to write
    req.ap = 0;
    req.ap.csr_write = 1;
    start_item(req);
    finish_item(req);
    
    // Directed Test 2: Write to CSR with maximum value
    `uvm_info(get_type_name(), "[Directed Test 2] CSR Write: Maximum value", UVM_LOW);
    req.a_in = 32'hFFFFFFFF;  // Maximum value
    req.b_in = 32'h87654321;  // Value to write
    req.ap = 0;
    req.ap.csr_write = 1;
    start_item(req);
    finish_item(req);
    

    // Directed Test 3: Write to CSR with alternating bit pattern
    `uvm_info(get_type_name(), "[Directed Test 3] CSR Write: Alternating bit pattern", UVM_LOW);
    req.a_in = 32'hAAAAAAAA;  // Alternating bit pattern
    req.b_in = 32'h55555555;  // Value to write
    req.ap = 0;
    req.ap.csr_write = 1;     
    req.ap.csr_imm = 1;
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
endclass: bmu_csr_write_sequence
