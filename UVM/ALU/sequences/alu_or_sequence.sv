class alu_or_sequence extends uvm_sequence #(alu_sequence_item);
`uvm_object_utils(alu_or_sequence) 
function new(string name = "alu_or_sequence");
  super.new(name);
endfunction: new
task body();
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
        opcode == 3'b011; // for addition
    };
    start_item(req);
    finish_item(req);
    #10;
  
endtask: body
endclass: alu_or_sequence