class bmu_reset_sequence extends uvm_sequence#(bmu_sequence_item);
  
`uvm_object_utils(bmu_reset_sequence)

// Configuration parameters
int reset_cycles = 1;        // Number of cycles to hold reset
int post_reset_cycles = 1;   // Number of cycles after reset release

function new(string name = "bmu_reset_sequence");
    super.new(name);
endfunction: new

virtual task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    `uvm_info(get_type_name(), "Starting Reset Sequence", UVM_LOW)
    
    // ============== PHASE 1: Assert Reset ================================================

    `uvm_info(get_type_name(), "Phase 1: Asserting reset", UVM_MEDIUM)

    start_item(req);
    // Initialize all signals to safe values
    req.rst_l = 1'b0; // Assert reset (active low)
    req.scan_mode = 1'b0;
    req.valid_in = 1'b0;     
    req.csr_ren_in = 1'b0;     
    req.csr_rddata_in = 32'h0;  
    req.a_in = 32'h0;    
    req.b_in = 32'h0;          
    req.ap = '0;              
    finish_item(req);
    
    // ============== PHASE 2: Hold Reset ======================================================

    //`uvm_info(get_type_name(), $sformatf("Phase 2: Holding reset for %0d cycles", reset_cycles), UVM_MEDIUM)
    
    // repeat(reset_cycles) begin
    //     start_item(req);
    //     // Keep reset asserted and all signals stable
    //     req.rst_l = 1'b0;
    //     req.scan_mode = 1'b0;
    //     req.valid_in = 1'b0;
    //     req.csr_ren_in = 1'b0;
    //     req.csr_rddata_in = 32'h0;
    //     req.a_in = 32'h0;
    //     req.b_in = 32'h0;
    //     req.ap = '0;
    //     finish_item(req);
    // end
    
    // ============== PHASE 3: Release Reset ======================================================

    `uvm_info(get_type_name(), "Phase 3: Releasing reset", UVM_MEDIUM)
    
    start_item(req);
    // Release reset while keeping other signals stable
    req.rst_l = 1'b1;           // Release reset
    req.scan_mode = 1'b0;       
    req.valid_in = 1'b0;        
    req.csr_ren_in = 1'b0;      
    req.csr_rddata_in = 32'h0;  
    req.a_in = 32'h0;          
    req.b_in = 32'h0;
    req.ap = '0;                
    finish_item(req);
    
    // ============== PHASE 4: Post-Reset Stabilization ============================================
    
    //`uvm_info(get_type_name(), $sformatf("Phase 4: Post-reset stabilization for %0d cycles", post_reset_cycles), UVM_MEDIUM)
    
    // repeat(post_reset_cycles) begin
    //     start_item(req);
    //     req.rst_l = 1'b1;
    //     req.scan_mode = 1'b0;
    //     req.valid_in = 1'b0;
    //     req.csr_ren_in = 1'b0;
    //     req.csr_rddata_in = 32'h0;
    //     req.a_in = 32'h0;
    //     req.b_in = 32'h0;
    //     req.ap = '0;
    //     finish_item(req);
    // end
    
    `uvm_info(get_type_name(), "Reset Sequence Completed - DUT is ready for operation", UVM_LOW)
    
endtask: body

endclass: bmu_reset_sequence