class bmu_scoreboard extends uvm_scoreboard;

`uvm_component_utils(bmu_scoreboard)

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction: new

uvm_analysis_imp#(bmu_sequence_item,bmu_scoreboard) exp;
bmu_sequence_item refPacket; // Reference packet for comparison

function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    exp= new("exp",this);
    refPacket = new();
endfunction

bmu_sequence_item packetQueue [$];

function void write(bmu_sequence_item req); 
    packetQueue.push_back(req); 
endfunction

// Function to print only the active signal name and value
function void doo_print(bmu_sequence_item packet);
    string active_signals[$];
    string signal_info;
    
    // Check each signal in the ap struct and collect active ones
    if (packet.ap.csr_write) active_signals.push_back("csr_write=1");
    if (packet.ap.csr_imm) active_signals.push_back("csr_imm=1");
    if (packet.ap.zbb) active_signals.push_back("zbb=1");
    if (packet.ap.zbp) active_signals.push_back("zbp=1");
    if (packet.ap.zba) active_signals.push_back("zba=1");
    if (packet.ap.zbs) active_signals.push_back("zbs=1");
    if (packet.ap.land) active_signals.push_back("land=1");
    if (packet.ap.lxor) active_signals.push_back("lxor=1");
    if (packet.ap.sll) active_signals.push_back("sll=1");
    if (packet.ap.sra) active_signals.push_back("sra=1");
    if (packet.ap.rol) active_signals.push_back("rol=1");
    if (packet.ap.bext) active_signals.push_back("bext=1");
    if (packet.ap.sh3add) active_signals.push_back("sh3add=1");
    if (packet.ap.add) active_signals.push_back("add=1");
    if (packet.ap.slt) active_signals.push_back("slt=1");
    if (packet.ap.sub) active_signals.push_back("sub=1");
    if (packet.ap.clz) active_signals.push_back("clz=1");
    if (packet.ap.cpop) active_signals.push_back("cpop=1");
    if (packet.ap.siext_h) active_signals.push_back("siext_h=1");
    if (packet.ap.min) active_signals.push_back("min=1");
    if (packet.ap.packu) active_signals.push_back("packu=1");
    if (packet.ap.gorc) active_signals.push_back("gorc=1");
    
    // Format the output based on number of active signals
    if (active_signals.size() == 0) begin
        signal_info = "No active signals";
    end else begin
        signal_info = $sformatf("Active signal(s) (%0d): ", active_signals.size());
        foreach (active_signals[i]) begin
            if (i == 0) signal_info = {signal_info, active_signals[i]};
            else signal_info = {signal_info, ", ", active_signals[i]};
        end
    end
    
    `uvm_info("Scoreboard", $sformatf("A=%0d, B=%0d, %s, Result=%0d, Error=%0b", 
              packet.a_in, packet.b_in, signal_info, packet.result_ff, packet.error), UVM_LOW);
endfunction

task run_phase(uvm_phase phase);
    bmu_sequence_item packet;
    forever begin
    wait(packetQueue.size>0);
    packet = packetQueue.pop_front();
    // bmu_RF(packet.A,packet.B,packet.opcode, this.refPacket.result, this.refPacket.error); 
    
    // Use the custom do_print function instead of the default print
    doo_print(packet);
    
    // if(is_equal(packet,this.refPacket)) begin 
    // `uvm_info("[Pass]", $sformatf("------ :: Match :: ------ "), UVM_LOW);  
    // `uvm_info("MATCH", $sformatf("expected %d, got %d", this.refPacket.result, packet.result) ,UVM_LOW); 
    // end
    // else begin 
    // `uvm_info("[Fail]", $sformatf("------ :: Mismatch :: ------"), UVM_LOW); 
    // `uvm_info("MATCH", $sformatf("expected %d, got %d", this.refPacket.result, packet.result) ,UVM_LOW); 
    // end
    end
endtask

// function bit is_equal(bmu_sequence_item reference, bmu_sequence_item packet); 
//     if(reference.A === packet.A && 
//     reference.B === packet.B && 
//     reference.opcode === packet.opcode && 
//     reference.result === packet.result &&
//     reference.error === packet.error
//     ) return 1; 
//     else return 0; 
// endfunction

// static task bmu_RF(input logic signed [31:0] A, 
// input logic [31:0] B, 
// input logic [2:0] opcode, 
// output logic [31:0] result, 
// output logic error); 
// error = 0; // Initialize error flag 
// case (opcode) 
//     3'b000: begin 
//     // Addition operation 
//     result = A + B; 
//     if ((A > 0 && B > 0 && result < 0) || (A < 0 && B < 0 && result > 0))  
//     error = 1; 
//     end
//     3'b001: begin 
//     // Subtraction operation (A - B) 
//     result = A - B; 
//     if ((A < 0 && B > 0 && result > A) || (A > 0 && B < 0 && result < A))  
//     error = 1; 
//     end 
//     3'b010: begin 
//     // AND operation 
//     result = A & B; 
//     end 
//     3'b011: begin
//         // OR operation 
//     result = A | B; 
//     end 
//     3'b100: begin 
//     // XOR operation 
//     result = A ^ B; 
//     end 
//     default: begin
//     result = 0; 
//     error = 1'b1; // Set error flag for invalid opcode 
//     end
// endcase
// endtask

// endclass: bmu_scoreboard

endclass: bmu_scoreboard