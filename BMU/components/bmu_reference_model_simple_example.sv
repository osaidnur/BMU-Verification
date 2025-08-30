// Version 1: WITHOUT uvm_object (Pure SystemVerilog Class)
class bmu_reference_model_simple;
    
    // Constructor (no UVM inheritance)
    function new();
        // Simple constructor
    endfunction
    
    // Main function to compute BMU result based on sequence item
    virtual function struct packed {
        logic [31:0] data;
        logic error;
    } compute_result(input bmu_sequence_item packet);
        
        struct packed {
            logic [31:0] data;
            logic error;
        } result;
        logic [32:0] add_result_extended;
        logic add_overflow;
        
        // Initialize result
        result.data = 32'h0;
        result.error = 1'b0;
        
        // Default: no operation
        if (!packet.valid_in) begin
            result.data = 32'h0;
            result.error = 1'b0;
            return result;
        end
        
        // Addition operation
        if (packet.ap.add) begin
            add_result_extended = {packet.a_in[31], packet.a_in} + {packet.b_in[31], packet.b_in};
            result.data = add_result_extended[31:0];
            add_overflow = (add_result_extended[32] != add_result_extended[31]);
            result.error = add_overflow;
        end
        // ... rest of operations would be the same
        else begin
            result.data = 32'h0;
            result.error = 1'b1;
        end
        
        return result;
    endfunction
    
endclass : bmu_reference_model_simple
