class bmu_sequence_item extends uvm_sequence_item;
// inputs
rand logic rst_l ;
rand logic signed [31:0] a_in;
rand logic signed [31:0] b_in;
rand logic scan_mode ;
rand logic valid_in ;
rand logic csr_ren_in;
rand logic [31:0] csr_rddata_in ;

rand struct ap {
  logic csr_write;
  logic csr_imm;

  logic zbb;
  logic zbp;
  logic zba;
  logic zbs;

  logic land;
  logic lxor;

  logic sll;
  logic sra;
  logic rol;
  logic bext;

  logic sh3add;

  logic add;
  logic slt;
  logic sub;

  logic clz;
  logic cpop;
  logic siext_h;
  logic min;
  logic packu;
  logic gorc;
} ;

// outputs
logic signed [31:0] result_ff;
logic error ;

`uvm_object_utils_begin(bmu_sequence_item)
    `uvm_field_int(rst_l,UVM_ALL_ON)
    `uvm_field_int(a_in,UVM_ALL_ON)
    `uvm_field_int(b_in,UVM_ALL_ON)
    `uvm_field_int(scan_mode,UVM_ALL_ON)
    `uvm_field_int(valid_in,UVM_ALL_ON)
    `uvm_field_int(ap,UVM_ALL_ON)
    `uvm_field_int(csr_ren_in,UVM_ALL_ON)
    `uvm_field_int(csr_rddata_in,UVM_ALL_ON)
    `uvm_field_int(result_ff,UVM_ALL_ON)
    `uvm_field_int(error,UVM_ALL_ON)
`uvm_object_utils_end

// the constructor in the sequence item doesn't need a parent
// but the uvm_component constructor does
function new(string name = "bmu_sequence_item");
  super.new(name);
endfunction: new

endclass: bmu_sequence_item