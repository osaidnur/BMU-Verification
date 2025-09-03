class bmu_subscriber extends uvm_subscriber #(bmu_sequence_item); 
`uvm_component_utils(bmu_subscriber) 

bmu_sequence_item sub; 

covergroup bmuCoverage;
    A: coverpoint sub.a_in; 
    B: coverpoint sub.b_in; 
    AP_ADD: coverpoint sub.ap.add; 
    AP_SUB: coverpoint sub.ap.sub; 
    AP_LAND: coverpoint sub.ap.land; 
    AP_LXOR: coverpoint sub.ap.lxor; 
    Result: coverpoint sub.result_ff; 
    Error: coverpoint sub.error; 
endgroup

function new(string name,uvm_component parent); 
    super.new(name,parent); 
    bmuCoverage = new(); 
    sub = new(); 
endfunction

function void write (bmu_sequence_item t);
    sub.a_in = t.a_in; 
    sub.b_in = t.b_in; 
    sub.ap = t.ap; 
    sub.result_ff = t.result_ff; 
    sub.error = t.error; 
    bmuCoverage.sample();
endfunction

function void report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    `uvm_info(get_type_name,  
    $sformatf("coverage: %d",bmuCoverage.get_coverage()), UVM_HIGH); 
endfunction
endclass