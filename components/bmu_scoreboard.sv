class bmu_scoreboard extends uvm_scoreboard;

`uvm_component_utils(bmu_scoreboard)

// Reference model instance
bmu_reference_model ref_model;

function new(string name,uvm_component parent);
    super.new(name,parent);
endfunction: new

uvm_analysis_imp#(bmu_sequence_item,bmu_scoreboard) exp;

function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    exp = new("exp",this);
    ref_model = bmu_reference_model::type_id::create("ref_model");
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
    if (packet.ap.unsign) active_signals.push_back("unsign=1");
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
    
    `uvm_info("Scoreboard", $sformatf("A=%0h, B=%0h, %s, Result=%0h, Error=%0b", 
              packet.a_in, packet.b_in, signal_info, packet.result_ff, packet.error), UVM_LOW);
endfunction

task run_phase(uvm_phase phase);
    bmu_sequence_item packet;
    struct packed {
        logic [31:0] data;
        logic error;
    } expected_result;
    bit match;
    
    forever begin
        wait(packetQueue.size > 0);
        packet = packetQueue.pop_front();
        
        // Get expected result from reference model
        expected_result = ref_model.compute_result(packet);
        
        // Compare with DUT output
        match = (packet.result_ff === expected_result.data) && 
                (packet.error === expected_result.error);
        
        // Use the custom do_print function
        doo_print(packet);
        
        // Print comparison result
        if (match) begin 
            `uvm_info("[PASS]", $sformatf("------ :: Match :: ------ "), UVM_LOW);  
            `uvm_info("MATCH", $sformatf("Expected: result=%0h error=%0b, Got: result=%0h error=%0b", 
                      expected_result.data, expected_result.error, packet.result_ff, packet.error), UVM_LOW); 
        end else begin 
            `uvm_error("[FAIL]", $sformatf("------ :: Mismatch :: ------")); 
            `uvm_info("MISMATCH", $sformatf("Expected: result=%0h error=%0b, Got: result=%0h error=%0b", 
                      expected_result.data, expected_result.error, packet.result_ff, packet.error), UVM_LOW); 
        end
    end
endtask

endclass: bmu_scoreboard