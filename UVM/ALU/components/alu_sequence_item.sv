class alu_sequence_item extends uvm_sequence_item;
// inputs
rand logic rst ;
rand logic [31:0] A;
rand logic [31:0] B;
rand logic [2:0] opcode;
// outputs
logic [31:0] result;
logic error ;

`uvm_object_utils_begin(alu_sequence_item)
    `uvm_field_int(rst,UVM_ALL_ON)
    `uvm_field_int(A,UVM_ALL_ON)
    `uvm_field_int(B,UVM_ALL_ON)
    `uvm_field_int(opcode,UVM_ALL_ON)
    `uvm_field_int(result,UVM_ALL_ON)
    `uvm_field_int(error,UVM_ALL_ON)
`uvm_object_utils_end

// the constructor in the sequence item doesn't need a parent
// but the uvm_component constructor does
function new(string name = "alu_sequence_item");
  super.new(name);
  
endfunction: new
endclass: alu_sequence_item