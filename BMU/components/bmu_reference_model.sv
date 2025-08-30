// BMU Reference Model Class for UVM Testbench
class bmu_reference_model extends uvm_object;
    `uvm_object_utils(bmu_reference_model)
    
    // Store the current active signals
    string active_signals[$];
    
    // Constructor
    function new(string name = "bmu_reference_model");
        super.new(name);
    endfunction
    
    // Function to record active signals from the packet
    virtual function void record_signals(input bmu_sequence_item packet);
        
        // Clear previous active signals
        active_signals.delete();
        
        // Check each signal in the ap struct and record active ones
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
        
        // Also check other control signals
        // if (packet.csr_ren_in) active_signals.push_back("csr_ren_in");
        // if (!packet.valid_in) active_signals.push_back("valid_in_low");
        // if (packet.scan_mode) active_signals.push_back("scan_mode");
        // if (!packet.rst_l) active_signals.push_back("rst_l_low");
    endfunction
    
    // Function to validate signal combinations (return 1 if valid, 0 if invalid)
    virtual function bit check_signals();
        
        if(active_signals.size() == 0) return 1; // No active signals is valid
        else if(active_signals.size() == 1) return 1; // Single active signal is valid
        else if(active_signals.size() > 2) return 0; // More than 2 active signals is invalid
        
        // csr_imm without csr_write is valid
        if(active_signals[0] == "csr_imm" && active_signals[1]=="csr_write" 
        || active_signals[0] == "csr_write" && active_signals[1]=="csr_imm") return 1;

        // land + zbb is valid
        if(active_signals[0] == "land" && active_signals[1]=="zbb"
        || active_signals[0] == "zbb" && active_signals[1]=="land") return 1;

        // lxor + zbb is valid
        if(active_signals[0] == "lxor" && active_signals[1]=="zbb"
        || active_signals[0] == "zbb" && active_signals[1]=="lxor") return 1;



        
        
        
        
       
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
        
        logic [32:0] add_result_extended; // Extended for overflow detection
        logic add_overflow;
        
        // Initialize result
        result.data = 32'h0;
        result.error = 1'b0;
        
        // Record active signals
        record_signals(packet);
        
        // NO operation - Reset conditions
        if (!packet.valid_in || packet.scan_mode || !packet.rst_l) begin
            result.data = 32'h0;
            result.error = 1'b0;
            return result;
        end

        // ==============================================================
        // === CSR Operations ===========================================
        // ==============================================================
        
        // CSR Read operation
        if (packet.csr_ren_in && active_signals.size()==0) begin
            result.data = packet.csr_rddata_in; // load the data from input
            result.error = 1'b0;
            return result;
        end
        else if(packet.csr_ren_in) begin
            // Invalid if other operations are also active - Raise error
            result.data = 32'h0;
            result.error = 1'b1;
            return result;
        end
        
        // CSR Write operation
        if(packet.ap.csr_write) begin
            if(packet.ap.csr_imm) begin
                result.data = packet.b_in; // For CSR immediate, use b_in as immediate value
                result.error = 1'b0;
                return result;
            end
            else begin
                result.data = packet.a_in; // For CSR write, use a_in as the value to write
                result.error = 1'b0; 
                return result;
            end
        end

        // Check if signal combination is valid
        if (!check_signals()) begin
            result.data = 32'h0;
            result.error = 1'b0;
            return result;
        end

        // ==============================================================
        // === Logical Operations =======================================
        // ==============================================================
        
        // Inverted AND
        if (packet.ap.land && packet.ap.zbb) begin
            result.data = packet.a_in & ~packet.b_in;
            result.error = 1'b0;
            return result;
        end
        
        // Normal AND
        else if (packet.ap.land) begin
            result.data = packet.a_in & packet.b_in;
            result.error = 1'b0;
            return result;
        end
        
        // Inverted XOR
        else if(packet.ap.lxor && packet.ap.zbb) begin
            result.data = packet.a_in ^ ~packet.b_in;
            result.error = 1'b0;
            return result;
        end

        // Normal XOR
        else if (packet.ap.lxor) begin
            result.data = packet.a_in ^ packet.b_in;
            result.error = 1'b0;
            return result;
        end
        
        // ================================================================
        // === Shifting and Masking Operations ============================
        // ================================================================
        
        if (packet.ap.add) begin
            add_result_extended = {packet.a_in[31], packet.a_in} + {packet.b_in[31], packet.b_in};
            result.data = add_result_extended[31:0];
            
            // Check for overflow (sign extension differs from MSB)
            add_overflow = (add_result_extended[32] != add_result_extended[31]);
            result.error = add_overflow;
        end
       
        // Logical AND
       
        // Logical XOR
        else if (packet.ap.lxor) begin
            result.data = packet.a_in ^ packet.b_in;
            result.error = 1'b0;
        end
        // Shift left logical
        else if (packet.ap.sll) begin
            result.data = packet.a_in << packet.b_in[4:0]; // Only use lower 5 bits for shift amount
            result.error = 1'b0;
        end
        // Shift right arithmetic
        else if (packet.ap.sra) begin
            result.data = packet.a_in >>> packet.b_in[4:0]; // Arithmetic right shift
            result.error = 1'b0;
        end
        // Rotate left
        else if (packet.ap.rol) begin
            result.data = (packet.a_in << packet.b_in[4:0]) | (packet.a_in >> (32 - packet.b_in[4:0]));
            result.error = 1'b0;
        end
        // Bit extract
        else if (packet.ap.bext) begin
            // Extract packet.a_in[packet.b_in[4:0]] into the LSB, zero-extend the rest
            result.data = {31'd0, packet.a_in[packet.b_in[4:0]]};
            result.error  = 1'b0;
        end
        // Shift by 3 and add
        else if (packet.ap.sh3add) begin
            result.data = (packet.a_in << 3) + packet.b_in;
            result.error = 1'b0;
        end
        // Set less than
        else if (packet.ap.slt) begin
            if (packet.ap.unsign) begin
                // Unsigned comparison: treat both operands as unsigned
                result.data = ($unsigned(packet.a_in) < $unsigned(packet.b_in)) ? 32'h1 : 32'h0;
            end else begin
                // Signed comparison: treat both operands as signed (default)
                result.data = ($signed(packet.a_in) < $signed(packet.b_in)) ? 32'h1 : 32'h0;
            end
            result.error = 1'b0;
        end
        // Minimum - requires both MIN and SUB to be active
        else if (packet.ap.min && packet.ap.sub) begin
            result.data = (packet.a_in < packet.b_in) ? packet.a_in : packet.b_in;
            result.error = 1'b0;
        end
        // Count Leading Zeros
        else if (packet.ap.clz) begin
            if (packet.a_in == 32'h0) begin
                // Special case: when input is all zeros, output is 0
                result.data = 32'h0;
            end else begin
                // Count leading zeros from MSB
                result.data = 32'h0;
                for (int i = 31; i >= 0; i--) begin
                    if (packet.a_in[i] == 1'b0) begin
                        result.data = result.data + 1;
                    end else begin
                        break; // Stop counting when we find the first 1
                    end
                end
            end
            result.error = 1'b0;
        end
        // Count Population (Count Ones)
        else if (packet.ap.cpop) begin
            // Count the number of '1' bits in packet.a_in
            result.data = 32'h0;
            for (int i = 0; i < 32; i++) begin
                if (packet.a_in[i] == 1'b1) begin
                    result.data = result.data + 1;
                end
            end
            result.error = 1'b0;
        end
        // Sign Extend Halfword
        else if (packet.ap.siext_h) begin
            // Take lower 16 bits of packet.a_in and sign-extend to 32 bits
            // If bit 15 is 0 (positive): extend with 0x0000
            // If bit 15 is 1 (negative): extend with 0xFFFF
            if (packet.a_in[15] == 1'b0) begin
                // Positive halfword - zero extend upper 16 bits
                result.data = {16'h0000, packet.a_in[15:0]};
            end else begin
                // Negative halfword - sign extend with 1s in upper 16 bits
                result.data = {16'hFFFF, packet.a_in[15:0]};
            end
            result.error = 1'b0;
        end
        // Pack Unsigned
        else if (packet.ap.packu) begin
            // Pack the upper 16 bits of both inputs into a 32-bit result
            // Result = {packet.b_in[31:16], packet.a_in[31:16]}
            // Lower 16 bits of both inputs are ignored
            result.data = {packet.b_in[31:16], packet.a_in[31:16]};
            result.error = 1'b0;
        end
        // Generalized OR Combine
        else if (packet.ap.gorc) begin
            // GORC operation: bitwise OR reduction within each byte of packet.a_in
            // Valid only when packet.b_in[4:0] = 5'b00111 (7)
            // If any bit in a byte is 1 → entire byte becomes 0xFF
            // If all bits in a byte are 0 → byte becomes 0x00
            if (packet.b_in[4:0] == 5'b00111) begin
                // Process each byte independently
                result.data[31:24] = (packet.a_in[31:24] != 8'h00) ? 8'hFF : 8'h00;  // Byte 3 (MSB)
                result.data[23:16] = (packet.a_in[23:16] != 8'h00) ? 8'hFF : 8'h00;  // Byte 2
                result.data[15:8]  = (packet.a_in[15:8]  != 8'h00) ? 8'hFF : 8'h00;  // Byte 1
                result.data[7:0]   = (packet.a_in[7:0]   != 8'h00) ? 8'hFF : 8'h00;  // Byte 0 (LSB)
                result.error = 1'b0;
            end else begin
                // Invalid packet.b_in[4:0] value - GORC requires packet.b_in[4:0] = 7
                result.data = 32'h0;
                result.error = 1'b1;
            end
        end
        // Default case - no valid operation or unimplemented operation
        else begin
            result.data = 32'h0;
            result.error = 1'b1; // Error for unsupported operation
        end
        
        return result;
    endfunction
endclass : bmu_reference_model
