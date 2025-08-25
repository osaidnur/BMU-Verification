import uvm_pkg::*;
`include "uvm_macros.svh"
import bmu_pkg::*;  // Import our package with all UVM components

module bmu_tb;
logic clk;

always #5 clk = ~clk;

initial begin
    clk = 0;
    // rst_l = 0;
    
    // #10;
    // rst_l = 1;
end

bmu_interface intf(clk);

BMU dut (
    .clk(clk),
    .rst_l(intf.rst_l),
    .scan_mode(intf.scan_mode),
    .valid_in(intf.valid_in),
    .csr_ren_in(intf.csr_ren_in),
    .csr_rddata_in(intf.csr_rddata_in),
    .a_in(intf.a_in),
    .b_in(intf.b_in),
    .ap(intf.ap),
    .result_ff(intf.result_ff),
    .error(intf.error)
);

initial begin
// set interface in config_db
    uvm_config_db#(virtual bmu_interface)::set(uvm_root::get(), "*", "vif", intf);
end

initial begin
    run_test("bmu_add_test");
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