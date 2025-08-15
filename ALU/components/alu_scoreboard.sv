class alu_scoreboard extends uvm_scoreboard;

`uvm_component_utils(alu_scoreboard)

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction: new

uvm_analysis_imp#(alu_sequence_item,alu_scoreboard) exp;
alu_sequence_item refPacket; // Reference packet for comparison

function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    exp= new("exp",this);
    refPacket = new();
endfunction

alu_sequence_item packetQueue [$];

function void write(alu_sequence_item req); 
    packetQueue.push_back(req); 
endfunction

task run_phase(uvm_phase phase);
    alu_sequence_item packet;
    forever begin
    wait(packetQueue.size>0);
    packet = packetQueue.pop_front();
    ALU_RF(packet.A,packet.B,packet.opcode, this.refPacket.result, this.refPacket.error); 
    
    if(is_equal(packet,this.refPacket)) begin 
    `uvm_info("[Pass]", $sformatf("------ :: Match :: ------ "), UVM_LOW);  
    `uvm_info("MATCH", $sformatf("expected %d, got %d", this.refPacket.result, packet.result) ,UVM_LOW); 
    end
    else begin 
    `uvm_info("[Fail]", $sformatf("------ :: Mismatch :: ------"), UVM_LOW); 
    `uvm_info("MATCH", $sformatf("expected %d, got %d", this.refPacket.result, packet.result) ,UVM_LOW); 
    end
    end
endtask

function bit is_equal(alu_sequence_item reference, alu_sequence_item packet); 
    if(reference.A === packet.A && 
    reference.B === packet.B && 
    reference.opcode === packet.opcode && 
    reference.result === packet.result && 
    reference.error === packet.error
    ) return 1; 
    else return 0; 
endfunction

static task ALU_RF(input logic signed [31:0] A, 
input logic [31:0] B, 
input logic [2:0] opcode, 
output logic [31:0] result, 
output logic error); 
error = 0; // Initialize error flag 
case (opcode) 
    3'b000: begin 
    // Addition operation 
    result = A + B; 
    if ((A > 0 && B > 0 && result < 0) || (A < 0 && B < 0 && result > 0))  
    error = 1; 
    end
    3'b001: begin 
    // Subtraction operation (A - B) 
    result = A - B; 
    if ((A < 0 && B > 0 && result > A) || (A > 0 && B < 0 && result < A))  
    error = 1; 
    end 
    3'b010: begin 
    // AND operation 
    result = A & B; 
    end 
    3'b011: begin
        // OR operation 
    result = A | B; 
    end 
    3'b100: begin 
    // XOR operation 
    result = A ^ B; 
    end 
    default: begin
    result = 0; 
    error = 1'b1; // Set error flag for invalid opcode 
    end
endcase
endtask

endclass: alu_scoreboard