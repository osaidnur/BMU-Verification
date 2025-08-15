import uvm_pkg::*;
`include "uvm_macros.svh"
import alu_pkg::*;  // Import our package with all UVM components
  
module alu_tb;
logic clk;
logic rst;

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    
    #1;
    rst = 1;
    #1;
    rst = 0;
end

alu_interface intf(clk,rst);

alu alu (
.clk(clk),
.rst(rst),
.A(intf.A),
.B(intf.B),
.opcode(intf.opcode),
.result(intf.result),
.error(intf.error)
);

initial begin
// set interface in config_db
    uvm_config_db#(virtual alu_interface)::set(uvm_root::get(), "*", "vif", intf);
end

initial begin
    run_test("alu_and_test");
end

// initial begin
// // $fsdbDumpfile("debug.fsdb"); // Set the output file for waveforms 
// // $fsdbDumpvars; // Dump all variables to the waveform file 
// // $fsdbDumpvars("+mda"); // Include multidimensional array data 
// // $fsdbDumpvars("+struct"); // Include struct data 
// // $fsdbDumpvars("+all"); // Include all data for debugging 
// // $fsdbDumpon; // Turn on waveform recording 
// $shm_open("debug.shm"); // Open shared memory for UVM debug data
// $shm_probe(0, "ALL"); // Probe all data for shared memory

// end

endmodule