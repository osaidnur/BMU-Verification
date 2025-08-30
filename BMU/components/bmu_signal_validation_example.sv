// Example demonstrating the new signal recording and validation functions

class bmu_signal_validation_example extends uvm_test;
    `uvm_component_utils(bmu_signal_validation_example)
    
    bmu_reference_model ref_model;
    
    function new(string name = "bmu_signal_validation_example", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ref_model = bmu_reference_model::type_id::create("ref_model");
    endfunction
    
    task run_phase(uvm_phase phase);
        bmu_sequence_item test_packet;
        bit is_valid;
        string signal_list;
        
        phase.raise_objection(this);
        
        `uvm_info("SIGNAL_VALIDATION", "=== Signal Recording and Validation Examples ===", UVM_LOW);
        
        // Create test packet
        test_packet = bmu_sequence_item::type_id::create("test_packet");
        
        // Example 1: Valid single operation (ADD)
        `uvm_info("SIGNAL_VALIDATION", "--- Example 1: Valid Single Operation (ADD) ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.add = 1'b1;
        test_packet.valid_in = 1'b1;
        test_packet.scan_mode = 1'b0;
        test_packet.rst_l = 1'b1;
        test_packet.csr_ren_in = 1'b0;
        
        // Record signals
        ref_model.record_signals(test_packet);
        
        // Check validation
        is_valid = ref_model.check_signal_combination();
        
        // Display results
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 2: Valid operation with modifier (SLT + UNSIGN)
        `uvm_info("SIGNAL_VALIDATION", "--- Example 2: Valid Operation with Modifier (SLT + UNSIGN) ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.slt = 1'b1;
        test_packet.ap.unsign = 1'b1;
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 3: Valid dual operation (MIN + SUB)
        `uvm_info("SIGNAL_VALIDATION", "--- Example 3: Valid Dual Operation (MIN + SUB) ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.min = 1'b1;
        test_packet.ap.sub = 1'b1;
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 4: Invalid combination (ADD + SLL)
        `uvm_info("SIGNAL_VALIDATION", "--- Example 4: Invalid Combination (ADD + SLL) ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.add = 1'b1;
        test_packet.ap.sll = 1'b1;  // Invalid: two operations
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 5: Invalid - MIN without SUB
        `uvm_info("SIGNAL_VALIDATION", "--- Example 5: Invalid - MIN without SUB ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.min = 1'b1;  // MIN requires SUB to be active too
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 6: Valid CSR operation
        `uvm_info("SIGNAL_VALIDATION", "--- Example 6: Valid CSR Operation ---", UVM_LOW);
        test_packet.ap = '{default: 0};  // No ap signals active
        test_packet.csr_ren_in = 1'b1;   // CSR read active
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        // Example 7: Invalid CSR with other operation
        `uvm_info("SIGNAL_VALIDATION", "--- Example 7: Invalid CSR with Other Operation ---", UVM_LOW);
        test_packet.ap = '{default: 0};
        test_packet.ap.add = 1'b1;       // Operation signal active
        test_packet.csr_ren_in = 1'b1;   // CSR read also active (invalid)
        
        ref_model.record_signals(test_packet);
        is_valid = ref_model.check_signal_combination();
        
        signal_list = "";
        foreach (ref_model.active_signals_queue[i]) begin
            if (i == 0) signal_list = ref_model.active_signals_queue[i];
            else signal_list = {signal_list, ", ", ref_model.active_signals_queue[i]};
        end
        
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Active signals: [%s]", signal_list), UVM_LOW);
        `uvm_info("SIGNAL_VALIDATION", $sformatf("Signal combination valid: %0b", is_valid), UVM_LOW);
        
        `uvm_info("SIGNAL_VALIDATION", "=== End of Signal Validation Examples ===", UVM_LOW);
        
        phase.drop_objection(this);
    endtask
    
endclass
