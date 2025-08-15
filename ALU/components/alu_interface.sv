interface alu_interface(input logic clk, rst); 
// Input and output signals 
logic signed [31:0] A; // Operand 1
logic [31:0] B; // Operand 2 
logic [2:0] opcode; // Opcode 
logic [31:0] result; // Output result 
logic error; // Error flag for overflow

clocking driver_cb @(negedge clk);
default input #1 output #0;
output A;
output B;
output opcode;
endclocking

clocking monitor_cb @(posedge clk); 
default input #0 output #1;
input A;
input B;
input opcode;
input result;
input error;
endclocking

modport driver_mod (clocking driver_cb,input clk);
modport monitor_mod (clocking monitor_cb,input clk);

endinterface