module tb_control;

  // Signals
  logic clk;
  logic rst_;
  logic zero;
  opcode_t opcode;
  logic mem_wr, mem_rd, load_ir, halt, inc_pc, load_ac, load_pc;

  // Instantiate the control module
  control dut (
    .clk(clk),
    .rst_(rst_),
    .zero(zero),
    .opcode(opcode),
    .mem_wr(mem_wr),
    .mem_rd(mem_rd),
    .load_ir(load_ir),
    .halt(halt),
    .inc_pc(inc_pc),
    .load_ac(load_ac),
    .load_pc(load_pc)
  );

  // Clock generator
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
  end

  // Stimulus
  initial begin
    $display("========================");
    $display("Starting FSM Controller ");
    $display("========================");
    
    // initialize
    rst_ = 1;
    
    zero = 0;
    opcode = ADD;
    repeat (9) begin
      @(posedge clk); // Wait for clock rising edge
      $display("Current State: %0d, Opcode: %0d, mem_wr: %b, mem_rd: %b, load_ir: %b, halt: %b, inc_pc: %b, load_ac: %b, load_pc: %b",
               dut.current_state, opcode, mem_wr, mem_rd, load_ir, halt, inc_pc, load_ac, load_pc);
    end

    opcode = SKZ;
    zero = 1; 
    repeat (9) begin
      @(posedge clk); // Wait for clock rising edge
      $display("Current State: %0d, Opcode: %0d, mem_wr: %b, mem_rd: %b, load_ir: %b, halt: %b, inc_pc: %b, load_ac: %b, load_pc: %b",
               dut.current_state, opcode, mem_wr, mem_rd, load_ir, halt, inc_pc, load_ac, load_pc);
    end


    $display("=====================");
    $display("FSM Controller Ended");
    $display("=====================");
    $finish;
  end

endmodule
