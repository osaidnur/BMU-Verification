class bmu_valid_in_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_valid_in_sequence)

function new(string name = "bmu_valid_in_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // ==========================================================================================================
    // ==================== Valid In Control Testing ============================================================
    // ==========================================================================================================

    // First, perform a normal ADD operation
    `uvm_info(get_type_name(), "[Valid In Test 1] Perform ADD operation - valid_in is enabled", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
        csr_ren_in == 0;
        a_in == 32'h12345678;
        b_in == 32'h87654321;
    });
    req.ap = 0;
    req.ap.add = 1;
    finish_item(req);
    

    // Now disable valid_in - the output should go to zero
    `uvm_info(get_type_name(), "[Valid In Test 2] Disable valid_in", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 0;  // DISABLE valid_in
        csr_ren_in == 0;
        a_in == 32'hFFFFFFFF;  // Different inputs
        b_in == 32'hFFFFFFFF;  // Different inputs
    });
    req.ap = 0;
    req.ap.add = 1;  // Operation signals still active
    finish_item(req);

    
    // Re-enable valid_in with a new operation (AND)
    `uvm_info(get_type_name(), "[Valid In Test 3] Re-enable valid_in with new operation", UVM_LOW);
    start_item(req);
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;  // RE-ENABLE valid_in
        csr_ren_in == 0;
        a_in == 32'h55555555;
        b_in == 32'h55555555;
    });
    req.ap = 0;
    req.ap.land = 1;  // AND operation
    finish_item(req);
    
    
    // Test multiple cycles with valid_in disabled
    `uvm_info(get_type_name(), "[Valid In Test 4] Multiple cycles with valid_in disabled", UVM_LOW);
    repeat(3) begin
        start_item(req);
        void'(req.randomize() with {
            rst_l == 1;
            scan_mode == 0;
            valid_in == 0;  // Keep valid_in disabled
            csr_ren_in == 0;
        });
        req.ap = 0;  // No operations active
        finish_item(req);
    end

    // Add idle cycles
    repeat(2) begin
        start_item(req);
        req.rst_l = 1;
        req.scan_mode = 0;
        req.valid_in = 0;  // No valid transaction - idle cycle
        req.csr_ren_in = 0;
        req.ap = 0;  // No operations active
        finish_item(req);
    end
    
endtask
endclass
