class bmu_cpop_test extends uvm_test;
`uvm_component_utils(bmu_cpop_test)

bmu_environment env;
bmu_cpop_sequence bmu_sequence;
bmu_reset_sequence reset_seq;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bmu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bmu_sequence = bmu_cpop_sequence::type_id::create("bmu_cpop_sequence");
    reset_seq = bmu_reset_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agent.sequencer);
    bmu_sequence.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_type_name, "========= End of CPOP Test =========", UVM_LOW);
endtask
endclass