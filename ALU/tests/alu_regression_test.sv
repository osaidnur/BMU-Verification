class alu_regression_test extends uvm_test;
`uvm_component_utils(alu_regression_test)

alu_environment env;

alu_add_sequence alu_add_seq;
alu_and_sequence alu_and_seq;
alu_or_sequence alu_or_seq;
alu_overflow_sequence alu_overflow_seq;
alu_random_sequence alu_random_seq;
alu_sub_sequence alu_sub_seq;
alu_undefined_opcode_sequence alu_undefined_seq;
alu_underflow_sequence alu_underflow_seq;
alu_xor_sequence alu_xor_seq;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_environment::type_id::create("environment",this);
endfunction

task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    alu_add_seq = alu_add_sequence::type_id::create("alu_add_sequence");
    alu_and_seq = alu_and_sequence::type_id::create("alu_and_sequence");
    alu_or_seq = alu_or_sequence::type_id::create("alu_or_sequence");
    alu_overflow_seq = alu_overflow_sequence::type_id::create("alu_overflow_sequence");
    alu_random_seq = alu_random_sequence::type_id::create("alu_random_sequence");
    alu_sub_seq = alu_sub_sequence::type_id::create("alu_sub_sequence");
    alu_undefined_seq = alu_undefined_opcode_sequence::type_id::create("alu_undefined_opcode_sequence");
    alu_underflow_seq = alu_underflow_sequence::type_id::create("alu_underflow_sequence");
    alu_xor_seq = alu_xor_sequence::type_id::create("alu_xor_sequence");

    repeat(500) begin
        alu_add_seq.start(env.agent.sequencer);
        alu_and_seq.start(env.agent.sequencer);
        alu_or_seq.start(env.agent.sequencer);
        alu_overflow_seq.start(env.agent.sequencer);
        alu_random_seq.start(env.agent.sequencer);
        alu_sub_seq.start(env.agent.sequencer);
        alu_undefined_seq.start(env.agent.sequencer);
        alu_underflow_seq.start(env.agent.sequencer);
        alu_xor_seq.start(env.agent.sequencer);
    end

    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
endtask
endclass
