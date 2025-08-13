class alu_subscriber extends uvm_subscriber #(alu_sequence_item); 
`uvm_component_utils(alu_subscriber) 

alu_sequence_item sub; 

covergroup aluCoverage; 
    A: coverpoint sub.A; 
    B: coverpoint sub.B; 
    Opcode: coverpoint sub.opcode ; 
    Result: coverpoint sub.result; 
    Error: coverpoint sub.error; 
endgroup

function new(string name,uvm_component parent); 
    super.new(name,parent); 
    aluCoverage = new(); 
    sub = new(); 
endfunction
function void write (alu_sequence_item t); 
    sub.A = t.A; 
    sub.B = t.B; 
    sub.opcode = t.opcode; 
    sub.result = t.result; 
    sub.error = t.error; 
    aluCoverage.sample();
endfunction
function void report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    `uvm_info(get_type_name,  
    $sformatf("coverage: %d",aluCoverage.get_coverage()), UVM_HIGH); 
endfunction
endclass