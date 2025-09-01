class alu_reset_sequence extends uvm_sequence#(alu_sequence_item);
  
`uvm_object_utils(alu_reset_sequence)

// Configuration parameters
int reset_cycles = 1;        // Number of cycles to hold reset
int post_reset_cycles = 1;   // Number of cycles after reset release

function new(string name = "alu_reset_sequence");
    super.new(name);
endfunction: new

virtual task body();
    alu_sequence_item req;
    req = alu_sequence_item::type_id::create("req");
    
    `uvm_info(get_type_name(), "Starting Reset Sequence", UVM_LOW)
    
    // ============== PHASE 1: Assert Reset ==============
    `uvm_info(get_type_name(), "Phase 1: Asserting reset", UVM_MEDIUM)
    
    start_item(req);
    
    // Initialize all signals to safe values
    req.rst = 1'b1; // Assert reset (active low)
    req.A = 32'h0;
    req.B = 32'h0;
    req.opcode = 3'b000; // NOP or safe operation
    req.result = 32'h0;
    req.error = 1'b0;
    
    finish_item(req);
    
    // ============== PHASE 2: Hold Reset ==============
    `uvm_info(get_type_name(), $sformatf("Phase 2: Holding reset for %0d cycles", reset_cycles), UVM_MEDIUM)
    
    repeat(reset_cycles) begin
        start_item(req);
        // Initialize all signals to safe values
        req.rst = 1'b1; // Assert reset (active low)
        req.A = 32'h0;
        req.B = 32'h0;
        req.opcode = 3'b000; // NOP or safe operation
        finish_item(req);
    end
    
    // ============== PHASE 3: Release Reset ==============
    `uvm_info(get_type_name(), "Phase 3: Releasing reset", UVM_MEDIUM)
    
    start_item(req);
    
    // Release reset while keeping other signals stable
    req.rst = 1'b0; // Assert reset (active low)
    req.A = 32'h0;
    req.B = 32'h0;
    req.opcode = 3'b000; // NOP or safe operation    
    
    finish_item(req);
    
    // ============== PHASE 4: Post-Reset Stabilization ==============
    
    `uvm_info(get_type_name(), $sformatf("Phase 4: Post-reset stabilization for %0d cycles", post_reset_cycles), UVM_MEDIUM)
    
    repeat(post_reset_cycles) begin
        start_item(req);
        req.rst = 1'b0; // Assert reset (active low)
        req.A = 32'h0;
        req.B = 32'h0;
        req.opcode = 3'b000; // NOP or safe operation  
        finish_item(req);
    end
    
    `uvm_info(get_type_name(), "Reset Sequence Completed - DUT is ready for operation", UVM_LOW)
    
endtask: body

endclass: alu_reset_sequence