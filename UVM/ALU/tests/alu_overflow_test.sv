class alu_overflow_test extends uvm_test;
`uvm_component_utils(alu_overflow_test)

alu_environment env;
alu_overflow_sequence alu_sequence;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    alu_sequence = alu_overflow_sequence::type_id::create("alu_overflow_sequence");
    repeat(500) begin
        alu_sequence.start(env.agent.sequencer);
    end
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
endtask
endclass
