module BMU (
    input logic clk,                    // Clock
    input logic rst_l,
    input logic signed [31:0] a_in,
    input logic signed [31:0] b_in,
    input logic scan_mode,
    input logic valid_in,
    input logic csr_ren_in,
    input logic [31:0] csr_rddata_in,
    
    // Control signals as packed struct
    input struct packed {
        logic csr_write;
        logic csr_imm;
        logic zbb;
        logic zbp;
        logic zba;
        logic zbs;
        logic land;
        logic lxor;
        logic sll;
        logic sra;
        logic rol;
        logic bext;
        logic sh3add;
        logic add;
        logic slt;
        logic unsign;
        logic sub;
        logic clz;
        logic cpop;
        logic siext_h;
        logic min;
        logic packu;
        logic gorc;
    } ap,
    
    output logic [31:0] result_ff,
    output logic error
);

    // Internal registers
    logic [31:0] result_next;
    logic error_next;
    
    // Overflow detection for addition
    logic add_overflow;
    logic [32:0] add_result_extended; // Extended for overflow detection
    
    // Function to check if only one operation signal is active
    function logic is_single_op_active();
        logic [20:0] op_signals;
        int count;
        
        // Pack all operation signals into a vector
        op_signals = {ap.csr_write, ap.csr_imm, ap.zbb, ap.zbp, ap.zba, ap.zbs, 
                     ap.land, ap.lxor, ap.sll, ap.sra, ap.rol, ap.bext, 
                     ap.sh3add, ap.add, ap.slt, ap.sub, ap.clz, ap.cpop, 
                     ap.siext_h, ap.min, ap.packu, ap.gorc};
        
        // Count number of active signals
        count = 0;
        for (int i = 0; i < 21; i++) begin
            if (op_signals[i]) count++;
        end
        
        // Return true if exactly one signal is active
        return (count == 1);
    endfunction
    
    // Combinational logic for operations
    always_comb begin
        result_next = 32'h0;
        error_next = 1'b0;
        add_overflow = 1'b0;
        add_result_extended = 33'h0;
        
        // Default: no operation
        if (!valid_in) begin
            result_next = 32'h0;
            error_next = 1'b0;
        end
        // Check if only one operation signal is active
        // else if (!is_single_op_active()) begin
        //     result_next = 32'h0;
        //     error_next = 1'b0; // Error: Multiple or no operation signals active
        //     // `uvm_info("BMU", "Error: Multiple or no operation signals active", UVM_LOW);
        // end
        // Addition operation
        else if (ap.add) begin
            add_result_extended = {a_in[31], a_in} + {b_in[31], b_in};
            result_next = add_result_extended[31:0];
            
            // Check for overflow (sign extension differs from MSB)
            add_overflow = (add_result_extended[32] != add_result_extended[31]);
            error_next = add_overflow;
        end
        // Subtraction operation (basic implementation)
        else if (ap.sub) begin
            add_result_extended = {a_in[31], a_in} - {b_in[31], b_in};
            result_next = add_result_extended[31:0];
            
            // Check for overflow
            add_overflow = (add_result_extended[32] != add_result_extended[31]);
            error_next = add_overflow;
        end
        // Logical AND
        else if (ap.land && ap.zbb) begin
            result_next = a_in & ~b_in;  // Inverted AND
            error_next = 1'b0;
        end
        else if (ap.land) begin
            result_next = a_in & b_in;   // Normal AND
            error_next = 1'b0;
        end
        // Logical XOR
        else if (ap.lxor) begin
            result_next = a_in ^ b_in;
            error_next = 1'b0;
        end
        // Shift left logical
        else if (ap.sll) begin
            result_next = a_in << b_in[4:0]; // Only use lower 5 bits for shift amount
            error_next = 1'b0;
        end
        // Shift right arithmetic
        else if (ap.sra) begin
            result_next = a_in >>> b_in[4:0]; // Arithmetic right shift
            error_next = 1'b0;
        end
        else if (ap.bext) begin
            // Extract a_in[b_in[4:0]] into the LSB, zero-extend the rest
            result_next = {31'd0, a_in[b_in[4:0]]};
            error_next  = 1'b0;
        end
        // Set less than
        else if (ap.slt) begin
            if (ap.unsign) begin
                // Unsigned comparison: treat both operands as unsigned
                result_next = ($unsigned(a_in) < $unsigned(b_in)) ? 32'h1 : 32'h0;
            end else begin
                // Signed comparison: treat both operands as signed (default)
                result_next = ($signed(a_in) < $signed(b_in)) ? 32'h1 : 32'h0;
            end
            error_next = 1'b0;
        end
        // Minimum - requires both MIN and SUB to be active
        else if (ap.min && ap.sub) begin
            result_next = (a_in < b_in) ? a_in : b_in;
            error_next = 1'b0;
        end
        // Count Leading Zeros
        else if (ap.clz) begin
            if (a_in == 32'h0) begin
                // Special case: when input is all zeros, output is 0
                result_next = 32'h0;
            end else begin
                // Count leading zeros from MSB
                result_next = 32'h0;
                for (int i = 31; i >= 0; i--) begin
                    if (a_in[i] == 1'b0) begin
                        result_next = result_next + 1;
                    end else begin
                        break; // Stop counting when we find the first 1
                    end
                end
            end
            error_next = 1'b0;
        end
        // Count Population (Count Ones)
        else if (ap.cpop) begin
            // Count the number of '1' bits in a_in
            result_next = 32'h0;
            for (int i = 0; i < 32; i++) begin
                if (a_in[i] == 1'b1) begin
                    result_next = result_next + 1;
                end
            end
            error_next = 1'b0;
        end
        // Sign Extend Halfword
        else if (ap.siext_h) begin
            // Take lower 16 bits of a_in and sign-extend to 32 bits
            // If bit 15 is 0 (positive): extend with 0x0000
            // If bit 15 is 1 (negative): extend with 0xFFFF
            if (a_in[15] == 1'b0) begin
                // Positive halfword - zero extend upper 16 bits
                result_next = {16'h0000, a_in[15:0]};
            end else begin
                // Negative halfword - sign extend with 1s in upper 16 bits
                result_next = {16'hFFFF, a_in[15:0]};
            end
            error_next = 1'b0;
        end
        // Pack Unsigned
        else if (ap.packu) begin
            // Pack the lower 16 bits of both inputs into a 32-bit result
            // Result = {a_in[15:0], b_in[15:0]}
            // Upper 16 bits of both inputs are ignored
            result_next = {b_in[31:16], a_in[31:16]};
            error_next = 1'b0;
        end
        // Default case - no valid operation or unimplemented operation
        else begin
            result_next = 32'h0;
            error_next = 1'b1; // Error for unsupported operation
        end
    end
    
    // Clocked output registers - outputs change on clock edge
    always_ff @(posedge clk or negedge rst_l) begin
        if (!rst_l) begin
            result_ff <= 32'h0;
            error <= 1'b0;
            // $display("[%0t] BMU: Reset asserted - result_ff <= 0, error <= 0", $time);
        end else begin
            result_ff <= result_next;
            error <= error_next;
        end
    end

endmodule : BMU
