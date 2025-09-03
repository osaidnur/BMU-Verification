class bmu_regression_test extends uvm_test;
`uvm_component_utils(bmu_regression_test)

bmu_environment env;

bmu_add_sequence add_sequence;
bmu_and_sequence and_sequence;
bmu_bext_sequence bext_sequence;
bmu_clz_sequence clz_sequence;
bmu_cpop_sequence cpop_sequence;
bmu_gorc_sequence gorc_sequence;
bmu_min_sequence min_sequence;
bmu_packu_sequence packu_sequence;
bmu_rol_sequence rol_sequence;
bmu_sh3add_sequence sh3add_sequence;
bmu_siext_h_sequence siext_h_sequence;
bmu_sll_sequence sll_sequence;
bmu_slt_sequence slt_sequence;
bmu_sra_sequence sra_sequence;
bmu_xor_sequence xor_sequence;
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
    add_sequence = bmu_add_sequence::type_id::create("bmu_add_sequence");
    and_sequence = bmu_and_sequence::type_id::create("bmu_and_sequence");
    bext_sequence = bmu_bext_sequence::type_id::create("bmu_bext_sequence");
    clz_sequence = bmu_clz_sequence::type_id::create("bmu_clz_sequence");
    cpop_sequence = bmu_cpop_sequence::type_id::create("bmu_cpop_sequence");
    gorc_sequence = bmu_gorc_sequence::type_id::create("bmu_gorc_sequence");
    min_sequence = bmu_min_sequence::type_id::create("bmu_min_sequence");
    packu_sequence = bmu_packu_sequence::type_id::create("bmu_packu_sequence");
    rol_sequence = bmu_rol_sequence::type_id::create("bmu_rol_sequence");
    sh3add_sequence = bmu_sh3add_sequence::type_id::create("bmu_sh3add_sequence");
    siext_h_sequence = bmu_siext_h_sequence::type_id::create("bmu_siext_h_sequence");
    sll_sequence = bmu_sll_sequence::type_id::create("bmu_sll_sequence");
    slt_sequence = bmu_slt_sequence::type_id::create("bmu_slt_sequence");
    sra_sequence = bmu_sra_sequence::type_id::create("bmu_sra_sequence");
    xor_sequence = bmu_xor_sequence::type_id::create("bmu_xor_sequence");
    reset_seq = bmu_reset_sequence::type_id::create("reset_seq");

    reset_seq.start(env.agent.sequencer);
    // # 10;
    add_sequence.start(env.agent.sequencer);
    // # 10;
    and_sequence.start(env.agent.sequencer);
    // # 10;
    bext_sequence.start(env.agent.sequencer);
    // # 10;
    clz_sequence.start(env.agent.sequencer);
    // # 10;
    cpop_sequence.start(env.agent.sequencer);
    // # 10;
    gorc_sequence.start(env.agent.sequencer);
    // # 10;
    min_sequence.start(env.agent.sequencer);
    // # 10;
    packu_sequence.start(env.agent.sequencer);
    // # 10;
    rol_sequence.start(env.agent.sequencer);
    // # 10;
    sh3add_sequence.start(env.agent.sequencer);
    // # 10;
    siext_h_sequence.start(env.agent.sequencer);
    // # 10;
    sll_sequence.start(env.agent.sequencer);
    // # 10;
    slt_sequence.start(env.agent.sequencer);
    // # 10;
    sra_sequence.start(env.agent.sequencer);
    // # 10;
    xor_sequence.start(env.agent.sequencer);

    phase.drop_objection(this);
    `uvm_info(get_type_name, "========= End of Regression Test =========", UVM_LOW);
endtask
endclass