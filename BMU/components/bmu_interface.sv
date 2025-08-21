interface bmu_interface(input logic clk, rst_l); 

// Input Signals
logic signed [31:0] a_in; 
logic signed [31:0] b_in; 
logic scan_mode ;
logic valid_in ;
logic csr_ren_in;
logic [31:0] csr_rddata_in ;

// Output Signals
logic [31:0] result_ff; 
logic error; 

struct ap {
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

};



clocking driver_cb @(negedge clk);
  default input #1 output #0;
  output a_in;
  output b_in;
  output scan_mode;
  output valid_in;
  output ap;
  output csr_ren_in;
  output csr_rddata_in;
  output result_ff;
  output error;
endclocking

clocking monitor_cb @(posedge clk); 
  default input #0 output #1; 
  input a_in;
  input b_in;
  input scan_mode;
  input valid_in;
  input ap;
  input csr_ren_in;
  input csr_rddata_in;
  input result_ff;
  input error;
endclocking

modport driver_mod (clocking driver_cb,input clk);
modport monitor_mod (clocking monitor_cb,input clk);

endinterface : bmu_interface