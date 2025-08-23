class bmu_sh3add_test extends uvm_test;
`uvm_component_utils(bmu_sh3add_test)

bmu_environment env;
bmu_sh3add_sequence bmu_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bmu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bmu_sequence = bmu_sh3add_sequence::type_id::create("bmu_sh3add_sequence");
    bmu_sequence.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_type_name, "========= End of SH3ADD Test =========", UVM_LOW);
endtask
endclass