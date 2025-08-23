class bmu_sll_test extends uvm_test;
`uvm_component_utils(bmu_sll_test)

bmu_environment env;
bmu_sll_sequence bmu_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bmu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bmu_sequence = bmu_sll_sequence::type_id::create("bmu_sll_sequence");
    bmu_sequence.start(env.agent.sequencer);
    phase.drop_objection(this);
    `uvm_info(get_type_name, "========= End of SLL Test =========", UVM_LOW);
endtask
endclass