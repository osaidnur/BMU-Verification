class bmu_slt_sequence extends uvm_sequence #(bmu_sequence_item);

`uvm_object_utils(bmu_slt_sequence)

function new(string name = "bmu_slt_sequence");
  super.new(name);
endfunction: new

task body();
    bmu_sequence_item req;
    req = bmu_sequence_item::type_id::create("req");
    
    // Reset the DUT
    req.rst_l = 0;
    start_item(req);
    `uvm_info(get_type_name(), "Reset the DUT - From slt_sequence", UVM_NONE);
    finish_item(req);
    
    #10;
    
    // Randomize the inputs
    void'(req.randomize() with {
        rst_l == 1;
        scan_mode == 0;
        valid_in == 1;
        csr_ren_in == 0;
    });
    
    // Clear all AP bits and set only slt
    req.ap = 0;
    req.ap.slt = 1;
    start_item(req);
    finish_item(req);
    #10;


  
  
endtask: body

endclass: bmu_slt_sequence