module DFF(
    input logic clk, clear, d, preset,
    output logic q
);

    reg q_next;

    // Combinational logic
    always_comb begin
        if (!preset & !clear)
            q_next = 1'bx;
        else if (!preset & clear)
            q_next = 1'b1;
        else if (preset & !clear)
            q_next = 1'b0;
        else
            q_next = d;
    end

    // Sequential logic for state update
    always_ff @(posedge clk) begin
        q <= q_next;
    end

endmodule