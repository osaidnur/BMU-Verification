class bmu_add_test extends uvm_test;
`uvm_component_utils(bmu_add_test)

bmu_environment env;
bmu_add_sequence bmu_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bmu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    bmu_sequence = bmu_add_sequence::type_id::create("bmu_add_sequence");
    repeat(500) begin
        bmu_sequence.start(env.agent.sequencer);
    end
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
endtask
endclass