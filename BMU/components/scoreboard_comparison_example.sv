// Scoreboard comparison: WITH vs WITHOUT uvm_object

class bmu_scoreboard_with_uvm_object extends uvm_scoreboard;
    `uvm_component_utils(bmu_scoreboard_with_uvm_object)
    
    bmu_reference_model ref_model;  // UVM object version
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // UVM Factory creation (preferred)
        ref_model = bmu_reference_model::type_id::create("ref_model");
        
        // Benefits:
        // - Factory override support
        // - Better debugging info
        // - UVM configuration database integration
        // - Automatic type registration
    endfunction
    
    // Rest of scoreboard...
endclass

//========================================================================

class bmu_scoreboard_without_uvm_object extends uvm_scoreboard;
    `uvm_component_utils(bmu_scoreboard_without_uvm_object)
    
    bmu_reference_model_simple ref_model;  // Simple SystemVerilog class
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Basic SystemVerilog instantiation
        ref_model = new();
        
        // Limitations:
        // - No factory override support
        // - Less debugging information
        // - No UVM configuration database integration
        // - Manual instantiation only
    endfunction
    
    // Rest of scoreboard works exactly the same...
    task run_phase(uvm_phase phase);
        bmu_sequence_item packet;
        auto expected_result;
        
        forever begin
            wait(packetQueue.size > 0);
            packet = packetQueue.pop_front();
            
            // Function call works EXACTLY the same!
            expected_result = ref_model.compute_result(packet);
            
            // Comparison logic is identical...
        end
    endtask
endclass
