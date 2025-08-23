class bmu_xor_test extends uvm_test;
`uvm_component_utils(bmu_xor_test)

bmu_environment env;
bmu_xor_sequence bmu_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bmu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bmu_sequence = bmu_xor_sequence::type_id::create("bmu_xor_sequence");
    bmu_sequence.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_type_name, "========= End of XOR Test =========", UVM_LOW);
endtask
endclass