module DFF(
    input logic clk,clear,d,preset,
    output logic q
    );

    always@(posedge clk,preset,clear)begin
        if (!preset & !clear) begin
            q <= 1'bx; 
        end 
        else if (!preset & clear) begin
            q <= 1'b1;
        end else if(preset & !clear) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    end
    
endmodule