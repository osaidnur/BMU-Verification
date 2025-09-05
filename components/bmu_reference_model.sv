class bmu_reference_model extends uvm_object;
    `uvm_object_utils(bmu_reference_model)
    
    // Store the current active signals
    string active_signals[$];
    
    // Store previous result to maintain RTL-like behavior
    logic [31:0] previous_result = 32'h0;
    logic previous_error = 1'b0;
    
    // Constructor
    function new(string name = "bmu_reference_model");
        super.new(name);
    endfunction
    
    // Function to record active signals from the packet
    virtual function void record_signals(input bmu_sequence_item packet);
        
        // Clear previous active signals
        active_signals.delete();
        
        // Check each signal and record active the active ones
        if (packet.ap.csr_write) active_signals.push_back("csr_write");
        if (packet.ap.csr_imm) active_signals.push_back("csr_imm");
        if (packet.ap.zbb) active_signals.push_back("zbb");
        if (packet.ap.zbp) active_signals.push_back("zbp");
        if (packet.ap.zba) active_signals.push_back("zba");
        if (packet.ap.zbs) active_signals.push_back("zbs");
        if (packet.ap.land) active_signals.push_back("land");
        if (packet.ap.lxor) active_signals.push_back("lxor");
        if (packet.ap.sll) active_signals.push_back("sll");
        if (packet.ap.sra) active_signals.push_back("sra");
        if (packet.ap.rol) active_signals.push_back("rol");
        if (packet.ap.bext) active_signals.push_back("bext");
        if (packet.ap.sh3add) active_signals.push_back("sh3add");
        if (packet.ap.add) active_signals.push_back("add");
        if (packet.ap.slt) active_signals.push_back("slt");
        if (packet.ap.unsign) active_signals.push_back("unsign");
        if (packet.ap.sub) active_signals.push_back("sub");
        if (packet.ap.clz) active_signals.push_back("clz");
        if (packet.ap.cpop) active_signals.push_back("cpop");
        if (packet.ap.siext_h) active_signals.push_back("siext_h");
        if (packet.ap.min) active_signals.push_back("min");
        if (packet.ap.packu) active_signals.push_back("packu");
        if (packet.ap.gorc) active_signals.push_back("gorc");
        
    endfunction
    
    // Validate signal combinations
    virtual function bit check_signals();
        
        if(active_signals.size() == 0) return 1; // No active signals is valid
        else if(active_signals.size() == 1) return 1; // Single active signal is valid
        else if(active_signals.size() > 3) return 0; // More than 3 active signals is invalid
        
        if(active_signals.size() == 2)begin

            // csr_imm without csr_write is valid
            if(active_signals[0] == "csr_imm" && active_signals[1]=="csr_write" 
            || active_signals[0] == "csr_write" && active_signals[1]=="csr_imm") return 1;

            // land + zbb is valid
            if(active_signals[0] == "land" && active_signals[1]=="zbb"
            || active_signals[0] == "zbb" && active_signals[1]=="land") return 1;

            // lxor + zbb is valid
            if(active_signals[0] == "lxor" && active_signals[1]=="zbb"
            || active_signals[0] == "zbb" && active_signals[1]=="lxor") return 1;

            // sh3add + zba is valid
            if(active_signals[0] == "sh3add" && active_signals[1]=="zba"
            || active_signals[0] == "zba" && active_signals[1]=="sh3add") return 1;

            // slt + sub is valid
            if(active_signals[0] == "slt" && active_signals[1]=="sub"
            || active_signals[0] == "sub" && active_signals[1]=="slt") return 1;

            // min + sub is valid
            if(active_signals[0] == "min" && active_signals[1]=="sub"
            || active_signals[0] == "sub" && active_signals[1]=="min") return 1;

            // Any other combination of two active signals is invalid
            return 0;
        end
        
        else if (active_signals.size() == 3) begin
            // slt + unsign + sub is valid (this is the only valid case)
            if(active_signals[0] == "slt" && active_signals[1]=="unsign" && active_signals[2]=="sub") return 1;

            // Any other combination of three active signals is invalid
            return 0;
        end

    endfunction

    // Main function to compute the result
    virtual function struct packed {
        logic [31:0] data;
        logic error;
    } compute_result(input bmu_sequence_item packet);
        
        struct packed {
            logic [31:0] data;
            logic error;
        } result;
        
        // Initialize result
        result.data = 32'h0;
        result.error = 1'b0;
        
        // Record active signals
        record_signals(packet);
        
        // When valid_in is low, it returns the previous result
        if (!packet.valid_in) begin
            result.data = previous_result;
            result.error = previous_error;
            return result;
        end
        
        // Reset condition - when reset is low, output goes to zero
        if (!packet.rst_l) begin
            result.data = 32'h0;
            result.error = 1'b0;
            // Update previous result for reset
            previous_result = 32'h0;
            previous_error = 1'b0;
            return result;
        end

        // ======================================================================================
        // === CSR Operations ===================================================================
        // ======================================================================================
        
        // CSR Read operation
        if (packet.csr_ren_in && active_signals.size()==0) begin
            result.data = packet.csr_rddata_in; // load the data from input
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        else if(packet.csr_ren_in) begin
            // Invalid if other operations are also active - Raise error
            result.data = 32'h0;
            result.error = 1'b1;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
        // ----------------------------------------------------
        // Check if signal combination is valid
        if (!check_signals()) begin
            result.data = 32'h0;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        // ----------------------------------------------------

        // CSR Write operation
        if(packet.ap.csr_write) begin
            if(packet.ap.csr_imm) begin
                result.data = packet.b_in; // For CSR immediate, use b_in as immediate value
                result.error = 1'b0;
                previous_result = result.data;
                previous_error = result.error;
                return result;
            end
            else begin
                result.data = packet.a_in; // For CSR write, use a_in as the value to write
                result.error = 1'b0;
                previous_result = result.data;
                previous_error = result.error;
                return result;
            end
        end

        // ======================================================================================
        // === Logical Operations ===============================================================
        // ======================================================================================
        
        // Inverted AND
        if (packet.ap.land && packet.ap.zbb) begin
            result.data = packet.a_in & ~packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
        // Normal AND
        else if (packet.ap.land) begin
            result.data = packet.a_in & packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
        // Inverted XOR
        else if(packet.ap.lxor && packet.ap.zbb) begin
            result.data = packet.a_in ^ ~packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Normal XOR 
        else if (packet.ap.lxor) begin
            result.data = packet.a_in ^ packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
        // ========================================================================================
        // === Shifting and Masking Operations ====================================================
        // ========================================================================================
        
        // Logical Left Shift - SLL
        else if (packet.ap.sll) begin
            result.data = packet.a_in << packet.b_in[4:0];
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Arithmetic Right Shift - SRA
        else if (packet.ap.sra) begin
            result.data = packet.a_in >>> packet.b_in[4:0];
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Rotate Left - ROL
        else if (packet.ap.rol) begin
            int shift_amount = packet.b_in[4:0];
            if (shift_amount == 0) begin
                result.data = packet.a_in;
            end else begin
                result.data = (packet.a_in << shift_amount) | (packet.a_in >> (32 - shift_amount));
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Bit Extract - BEXT
        else if (packet.ap.bext) begin
            result.data = {31'd0, packet.a_in[packet.b_in[4:0]]};
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Shift by 3 and Add - SH3ADD
        else if (packet.ap.sh3add && packet.ap.zba) begin
            result.data = (packet.a_in << 3) + packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        else if (packet.ap.sh3add) begin
            result.data = 32'h0;
            result.error = 1'b1;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // ========================================================================================
        // === Arithmetic Operations ==============================================================
        // ========================================================================================

        // Addition - ADD
        else if (packet.ap.add) begin
            result.data = packet.a_in + packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // =======================================================================================
        // === Bit Manipulation ==================================================================
        // =======================================================================================

        // Set on Less Than - SLT
        else if (packet.ap.slt && packet.ap.sub) begin
            if (packet.ap.unsign) begin
                // Unsigned comparison
                result.data = ($unsigned(packet.a_in) < $unsigned(packet.b_in)) ? 32'h1 : 32'h0;
            end else begin
                // Signed comparison
                result.data = ($signed(packet.a_in) < $signed(packet.b_in)) ? 32'h1 : 32'h0;
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Count Leading Zeros - CLZ
        else if (packet.ap.clz) begin
            if (packet.a_in == 32'h0) begin
                // when input is all zeros, the output is 0
                result.data = 32'h0;
            end else begin
                // Count leading zeros
                result.data = 32'h0;
                for (int i = 31; i >= 0; i--) begin
                    if (packet.a_in[i] == 1'b0) begin
                        result.data = result.data + 1;
                    end else begin
                        break;
                    end
                end
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Count Set Bits - CPOP
        else if (packet.ap.cpop) begin
            result.data = 32'h0;
            for (int i = 0; i < 32; i++) begin
                if (packet.a_in[i] == 1'b1) begin
                    result.data = result.data + 1;
                end
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Sign Extend Halfword - SIEXT_H
        else if (packet.ap.siext_h) begin
            if (packet.a_in[15] == 1'b0) begin
                result.data = {16'h0000, packet.a_in[15:0]};
            end else begin
                result.data = {16'hFFFF, packet.a_in[15:0]};
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Minimum - MIN
        else if (packet.ap.min && packet.ap.sub) begin
            result.data = ($signed(packet.a_in) < $signed(packet.b_in)) ? packet.a_in : packet.b_in;
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Pack Upper
        else if (packet.ap.packu) begin
            result.data = {packet.b_in[31:16], packet.a_in[31:16]};
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end

        // Bitwise OR Reduction within Bytes - GORC
        else if (packet.ap.gorc) begin
            if (packet.b_in[4:0] == 5'b00111) begin
                result.data[31:24] = (packet.a_in[31:24] != 8'h00) ? 8'hFF : 8'h00;
                result.data[23:16] = (packet.a_in[23:16] != 8'h00) ? 8'hFF : 8'h00;
                result.data[15:8] =  (packet.a_in[15:8] != 8'h00) ? 8'hFF : 8'h00;
                result.data[7:0] =   (packet.a_in[7:0] != 8'h00) ? 8'hFF : 8'h00;
            end else begin
                result.data = 32'h0;
            end
            result.error = 1'b0;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
        // Default case - no valid operation or unsupported operation
        else begin
            result.data = 32'h0;
            result.error = 1'b1;
            previous_result = result.data;
            previous_error = result.error;
            return result;
        end
        
    endfunction
endclass : bmu_reference_model
