interface bmu_interface(input logic clk); 

// Input and output signals 
logic signed [31:0] a_in; // Operand 1
logic signed [31:0] b_in; // Operand 2 
logic rst_l ;
logic scan_mode ;
logic valid_in ;
logic csr_ren_in;
logic [31:0] csr_rddata_in ;


struct packed {
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

} ap;

logic [31:0] result_ff; // Output result 
logic error; // Error flag for overflow

clocking driver_cb @(posedge clk);
  // default input #2step output #1step;
  output rst_l;
  output a_in;
  output b_in;
  output scan_mode;
  output valid_in;
  output ap;
  output csr_ren_in;
  output csr_rddata_in;
endclocking

clocking monitor_cb @(posedge clk); 
  // default input #5step output #1step; 
  input rst_l;
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