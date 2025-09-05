class bmu_subscriber extends uvm_subscriber #(bmu_sequence_item); 
`uvm_component_utils(bmu_subscriber) 

bmu_sequence_item sub; 

covergroup bmuCoverage;
    // Input operand coverage with special value bins
    A: coverpoint sub.a_in {
        bins zero = {0};
        bins ones = {32'hFFFFFFFF};
        bins max_pos = {32'h7FFFFFFF};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    B: coverpoint sub.b_in {
        bins zero = {0};
        bins ones = {32'hFFFFFFFF};
        bins max_pos = {32'h7FFFFFFF};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    // reset signal coverage
    RST: coverpoint sub.rst_l ;
    
    // valid_in signal
    VALID_IN: coverpoint sub.valid_in;
    
    // Arithmetic operations
    AP_ADD: coverpoint sub.ap.add;
    
    // Logical operations
    AP_LAND: coverpoint sub.ap.land;
    AP_LXOR: coverpoint sub.ap.lxor;
    
    // Shifting and masking operations
    AP_SLL: coverpoint sub.ap.sll;
    AP_SRA: coverpoint sub.ap.sra;
    AP_ROL: coverpoint sub.ap.rol;
    AP_BEXT: coverpoint sub.ap.bext;
    AP_SH3ADD: coverpoint sub.ap.sh3add;
    
    // Bit manipulation operations
    AP_SLT: coverpoint sub.ap.slt;
    AP_CLZ: coverpoint sub.ap.clz;
    AP_CPOP: coverpoint sub.ap.cpop;
    AP_SIEXT_H: coverpoint sub.ap.siext_h;
    AP_MIN: coverpoint sub.ap.min;
    AP_PACKU: coverpoint sub.ap.packu;
    AP_GORC: coverpoint sub.ap.gorc;
    
    // Extension controls
    AP_ZBB: coverpoint sub.ap.zbb;
    AP_ZBP: coverpoint sub.ap.zbp;
    AP_ZBA: coverpoint sub.ap.zba;
    AP_ZBS: coverpoint sub.ap.zbs;

    AP_UNSIGN: coverpoint sub.ap.unsign;
    
    // CSR operations
    AP_CSR_WRITE: coverpoint sub.ap.csr_write;
    AP_CSR_IMM: coverpoint sub.ap.csr_imm;
    
    // Result coverage
    Result: coverpoint sub.result_ff {
        bins zero = {0};
        bins ones = {32'hFFFFFFFF};
        bins max_pos = {32'h7FFFFFFF};
        bins max_neg = {32'h80000000};
        bins alt_pattern1 = {32'h55555555};
        bins alt_pattern2 = {32'hAAAAAAAA};
        bins other_values = default;
    }
    
    // Error coverage
    Error: coverpoint sub.error;
    
    // Cross coverage for critical combinations
    ARITH_OPS_CROSS: cross AP_ADD, AP_SUB, A, B {
        ignore_bins both_ops = binsof(AP_ADD) intersect {1} && binsof(AP_SUB) intersect {1};
    }
    
    LOGIC_OPS_CROSS: cross AP_LAND, AP_LXOR, A, B {
        ignore_bins both_ops = binsof(AP_LAND) intersect {1} && binsof(AP_LXOR) intersect {1};
    }
    
    ERROR_CONDITIONS: cross Error, AP_ADD, AP_SUB, A, B {
        bins overflow_add = binsof(Error) intersect {1} && binsof(AP_ADD) intersect {1};
        bins overflow_sub = binsof(Error) intersect {1} && binsof(AP_SUB) intersect {1};
    }
    
    VALID_OPERATION: cross VALID_IN, AP_ADD, AP_SUB, AP_LAND, AP_LXOR {
        ignore_bins invalid_with_ops = binsof(VALID_IN) intersect {0} && 
                                      (binsof(AP_ADD) intersect {1} || binsof(AP_SUB) intersect {1} || 
                                       binsof(AP_LAND) intersect {1} || binsof(AP_LXOR) intersect {1});
    }
    
endgroup

function new(string name,uvm_component parent); 
    super.new(name,parent); 
    bmuCoverage = new(); 
    sub = new(); 
endfunction

function void write (bmu_sequence_item t);
    sub.rst_l = t.rst_l;
    sub.a_in = t.a_in; 
    sub.b_in = t.b_in; 
    sub.valid_in = t.valid_in;
    sub.scan_mode = t.scan_mode;
    sub.csr_ren_in = t.csr_ren_in;
    sub.csr_rddata_in = t.csr_rddata_in;
    sub.ap = t.ap; 
    sub.result_ff = t.result_ff; 
    sub.error = t.error; 
    bmuCoverage.sample();
endfunction

function void report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    `uvm_info(get_type_name,  
    $sformatf("Overall Coverage: %.2f%%", bmuCoverage.get_coverage()), UVM_LOW);
    `uvm_info(get_type_name,  
    $sformatf("Input A Coverage: %.2f%%", bmuCoverage.A.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Input B Coverage: %.2f%%", bmuCoverage.B.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Arithmetic Operations Coverage: %.2f%%", 
              (bmuCoverage.AP_ADD.get_coverage() + bmuCoverage.AP_SUB.get_coverage())/2), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Logic Operations Coverage: %.2f%%", 
              (bmuCoverage.AP_LAND.get_coverage() + bmuCoverage.AP_LXOR.get_coverage())/2), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Error Coverage: %.2f%%", bmuCoverage.Error.get_coverage()), UVM_MEDIUM);
    `uvm_info(get_type_name,  
    $sformatf("Cross Coverage Summary - Arith Ops: %.2f%%, Logic Ops: %.2f%%, Errors: %.2f%%", 
              bmuCoverage.ARITH_OPS_CROSS.get_coverage(),
              bmuCoverage.LOGIC_OPS_CROSS.get_coverage(),
              bmuCoverage.ERROR_CONDITIONS.get_coverage()), UVM_MEDIUM);
endfunction
endclass