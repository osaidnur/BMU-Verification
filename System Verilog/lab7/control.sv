typedef enum logic [2:0] {
  HLT = 3'b000,
  SKZ = 3'b001,
  ADD = 3'b010,
  AND = 3'b011,
  XOR = 3'b100,
  LDA = 3'b101,
  STO = 3'b110,
  JMP = 3'b111
} opcode_t;

typedef enum logic [2:0] {
  INST_ADDR = 0,
  INST_FETCH = 1,
  INST_LOAD = 2,
  IDLE = 3,
  OP_ADDR = 4,
  OP_FETCH = 5,
  ALU_OP = 6,
  STORE = 7
} state_t;

module control(
  input logic clk,
  input logic rst_,    // Active low reset
  input logic zero,    // 1 if accumulator is zero
  input opcode_t opcode,
  output logic mem_wr, mem_rd, load_ir, halt, inc_pc, load_ac, load_pc
);

  // timeunit 1ns;
  // timeprecision 1ns;

  state_t current_state, next_state;

  // Asynchronous reset and state transition
  always_ff @(posedge clk or negedge rst_) begin
    if (!rst_)
      current_state <= INST_ADDR;
    else
      current_state <= next_state;
  end

  // State transition
  always_comb begin
    //next_state = current_state;
    unique case (current_state)
      INST_ADDR:   next_state = INST_FETCH;
      INST_FETCH:  next_state = INST_LOAD;
      INST_LOAD:   next_state = IDLE;
      IDLE:        next_state = OP_ADDR;
      OP_ADDR:     next_state = OP_FETCH;
      OP_FETCH:    next_state = ALU_OP;
      ALU_OP:      next_state = STORE ;
      STORE:       next_state = INST_ADDR;
      default:     next_state = INST_ADDR;
    endcase
  end

  // Outputs based on state and opcode
  always_comb begin
    
    // Default outputs
    mem_wr = 0;
    mem_rd = 0;
    load_ir = 0;
    halt = 0;
    inc_pc = 0;
    load_ac = 0;
    load_pc = 0;


    unique case (current_state)
      INST_FETCH: begin
        mem_rd = 1;
      end

      INST_LOAD,IDLE: begin
        mem_rd = 1;
        load_ir = 1;
      end

      OP_ADDR: begin
        halt = (opcode == HLT);
        inc_pc = 1;
      end
      
      OP_FETCH: begin
        mem_rd = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
      end

      ALU_OP: begin
        mem_rd = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
        inc_pc = (opcode == SKZ && zero);
        load_ac = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
        load_pc = (opcode == JMP);
      end

      STORE: begin
        mem_rd = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
        inc_pc = (opcode == JMP);
        load_ac = (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA);
        load_pc = (opcode == JMP);
        mem_wr = (opcode == STO);
      end
    endcase
  end

endmodule