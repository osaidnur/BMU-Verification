class alu_add_test extends uvm_test;
`uvm_component_utils(alu_add_test)

alu_environment env;
alu_add_sequence alu_sequence;
alu_reset_sequence alu_reset_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    alu_sequence = alu_add_sequence::type_id::create("alu_add_sequence");
    alu_reset_sequence = alu_reset_sequence::type_id::create("alu_reset_sequence");
    
    alu_reset_sequence.start(env.agent.sequencer);
    #10;
    alu_sequence.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
endtask
endclass