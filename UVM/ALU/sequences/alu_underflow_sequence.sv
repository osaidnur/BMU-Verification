class alu_underflow_sequence extends uvm_sequence #(alu_sequence_item);
  `uvm_object_utils(alu_underflow_sequence)
  // Constructor
  function new(string name = "underflow_sequence");
    super.new(name);
  endfunction
  // Body of the sequence
  virtual task body();
    alu_sequence_item req;
    req = alu_sequence_item::type_id::create("req");
    // Reset the DUT
    req.rst = 1;
    start_item(req);
    `uvm_info(get_type_name(), "Reset the DUT", UVM_NONE);
    finish_item(req);
    #10;
    // Randomize the inputs
    req.randomize() with {
        opcode == 3'b000;
        // Ensure the inputs are set to trigger underflow
        A == 32'h80000000; // Example value that could cause underflow
        B == 32'hFFFFFFFF; // Example value that could cause underflow
    };
    start_item(req);
    finish_item(req);
    #10;
    endtask: body
endclass: alu_underflow_sequence
