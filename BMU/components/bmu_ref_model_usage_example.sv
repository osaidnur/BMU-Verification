// Example of how to use the BMU Reference Model

class bmu_ref_model_usage_example extends uvm_test;
    `uvm_component_utils(bmu_ref_model_usage_example)
    
    bmu_reference_model ref_model;
    
    function new(string name = "bmu_ref_model_usage_example", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create reference model instance
        ref_model = bmu_reference_model::type_id::create("ref_model");
    endfunction
    
    task run_phase(uvm_phase phase);
        struct packed {
            logic [31:0] data;
            logic error;
        } result;
        
        bmu_sequence_item test_packet;
        
        phase.raise_objection(this);
        
        `uvm_info("USAGE_EXAMPLE", "=== BMU Reference Model Usage Examples ===", UVM_LOW);
        
        // Create a test packet for demonstrations
        test_packet = bmu_sequence_item::type_id::create("test_packet");
        
        // Example 1: Addition operation
        `uvm_info("USAGE_EXAMPLE", "--- Example 1: Addition ---", UVM_LOW);
        test_packet.a_in = 32'h12345678;
        test_packet.b_in = 32'h87654321;
        test_packet.ap = '{default: 0}; // Initialize all to 0
        test_packet.ap.add = 1'b1;      // Enable addition
        test_packet.valid_in = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("ADD: 0x12345678 + 0x87654321 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 2: SLL (Shift Left Logical)
        `uvm_info("USAGE_EXAMPLE", "--- Example 2: Shift Left Logical ---", UVM_LOW);
        test_packet.a_in = 32'hA5A5A5A5;
        test_packet.b_in = 32'h4;        // Shift by 4
        test_packet.ap = '{default: 0};
        test_packet.ap.sll = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("SLL: 0xA5A5A5A5 << 4 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 3: SLT (Set Less Than) - Signed comparison
        `uvm_info("USAGE_EXAMPLE", "--- Example 3: Set Less Than (Signed) ---", UVM_LOW);
        test_packet.a_in = -10;          // Negative number
        test_packet.b_in = 5;            // Positive number
        test_packet.ap = '{default: 0};
        test_packet.ap.slt = 1'b1;
        test_packet.ap.unsign = 1'b0; // Signed comparison
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("SLT (signed): -10 < 5 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 4: SLT (Set Less Than) - Unsigned comparison
        `uvm_info("USAGE_EXAMPLE", "--- Example 4: Set Less Than (Unsigned) ---", UVM_LOW);
        test_packet.a_in = -10;          // 0xFFFFFFF6 when unsigned
        test_packet.b_in = 5;            // 0x00000005 when unsigned
        test_packet.ap = '{default: 0};
        test_packet.ap.slt = 1'b1;
        test_packet.ap.unsign = 1'b1; // Unsigned comparison
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("SLT (unsigned): 0xFFFFFFF6 < 0x00000005 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 5: CLZ (Count Leading Zeros) - Normal case
        `uvm_info("USAGE_EXAMPLE", "--- Example 5: Count Leading Zeros ---", UVM_LOW);
        test_packet.a_in = 32'h00123456; // Has leading zeros
        test_packet.b_in = 32'h0;
        test_packet.ap = '{default: 0};
        test_packet.ap.clz = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("CLZ: 0x00123456 has %0d leading zeros, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 6: CLZ (Count Leading Zeros) - Special case (all zeros)
        `uvm_info("USAGE_EXAMPLE", "--- Example 6: CLZ Special Case (All Zeros) ---", UVM_LOW);
        test_packet.a_in = 32'h00000000; // All zeros - special case
        test_packet.b_in = 32'h0;
        test_packet.ap = '{default: 0};
        test_packet.ap.clz = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("CLZ: 0x00000000 (special case) = %0d, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 7: MIN operation (requires both min and sub)
        `uvm_info("USAGE_EXAMPLE", "--- Example 7: Minimum Operation ---", UVM_LOW);
        test_packet.a_in = 25;
        test_packet.b_in = 37;
        test_packet.ap = '{default: 0};
        test_packet.ap.min = 1'b1;
        test_packet.ap.sub = 1'b1; // Both required for MIN
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("MIN: min(25, 37) = %0d, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 8: GORC (Generalized OR Combine) - Valid case
        `uvm_info("USAGE_EXAMPLE", "--- Example 8: GORC Valid Case ---", UVM_LOW);
        test_packet.a_in = 32'h12345678; // Input data
        test_packet.b_in = 32'h7;        // b_in[4:0] = 7 (valid for GORC)
        test_packet.ap = '{default: 0};
        test_packet.ap.gorc = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("GORC: 0x12345678 with mask 7 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 9: GORC (Generalized OR Combine) - Invalid case
        `uvm_info("USAGE_EXAMPLE", "--- Example 9: GORC Invalid Case ---", UVM_LOW);
        test_packet.a_in = 32'h12345678; // Input data
        test_packet.b_in = 32'h3;        // b_in[4:0] = 3 (invalid for GORC)
        test_packet.ap = '{default: 0};
        test_packet.ap.gorc = 1'b1;
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("GORC: 0x12345678 with invalid mask 3 = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        // Example 10: Error case - no operation enabled
        `uvm_info("USAGE_EXAMPLE", "--- Example 10: No Operation (Error Case) ---", UVM_LOW);
        test_packet.a_in = 32'h12345678;
        test_packet.b_in = 32'h87654321;
        test_packet.ap = '{default: 0}; // No operation enabled
        
        result = ref_model.compute_result(test_packet);
        
        `uvm_info("USAGE_EXAMPLE", $sformatf("No operation: result = 0x%08h, error=%0b", 
                  result.data, result.error), UVM_LOW);
        
        `uvm_info("USAGE_EXAMPLE", "=== End of Usage Examples ===", UVM_LOW);
        
        phase.drop_objection(this);
    endtask
    
endclass
