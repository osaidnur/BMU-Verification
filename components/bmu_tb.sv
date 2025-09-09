import uvm_pkg::*;
`include "uvm_macros.svh"
import bmu_pkg::*;  // Import our package with all UVM components

module bmu_tb;
logic clk;

initial begin
    clk = 0;
    // #5;
    forever begin
       #5 clk = ~clk; 
    end

end

bmu_interface intf(clk);

// import the RTL package to access rtl_alu_pkt_t
import rtl_pkg::*;

// this dut will be connected to the interface signals
rtl_alu_pkt_t dut_ap;

always_comb begin
    // initialize to zeros (any missing or uncovered signals remain 0)
    dut_ap = '0;
    
    // map signals that have exact name matches
    dut_ap.csr_write = intf.ap.csr_write;
    dut_ap.csr_imm   = intf.ap.csr_imm;
    dut_ap.zbb       = intf.ap.zbb;
    dut_ap.zba       = intf.ap.zba;
    dut_ap.land      = intf.ap.land;
    dut_ap.lxor      = intf.ap.lxor;
    dut_ap.sll       = intf.ap.sll;
    dut_ap.sra       = intf.ap.sra;
    dut_ap.rol       = intf.ap.rol;
    dut_ap.bext      = intf.ap.bext;
    dut_ap.sh3add    = intf.ap.sh3add;
    dut_ap.add       = intf.ap.add;
    dut_ap.slt       = intf.ap.slt;
    dut_ap.unsign    = intf.ap.unsign;
    dut_ap.sub       = intf.ap.sub;
    dut_ap.clz       = intf.ap.clz;
    dut_ap.cpop      = intf.ap.cpop;
    dut_ap.siext_h   = intf.ap.siext_h;
    dut_ap.min       = intf.ap.min;
    dut_ap.packu     = intf.ap.packu;
    dut_ap.gorc      = intf.ap.gorc;
    
end

Bit_Manipulation_Unit dut (
    .clk(intf.clk),
    .rst_l(intf.rst_l),
    .scan_mode(intf.scan_mode),
    .valid_in(intf.valid_in),
    .csr_ren_in(intf.csr_ren_in),
    .csr_rddata_in(intf.csr_rddata_in),
    .a_in(intf.a_in),
    .b_in(intf.b_in),
    .ap(dut_ap),
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