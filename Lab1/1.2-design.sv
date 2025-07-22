module prbs (rrand, clk, reset) ;
input clk, reset;
output rrand;

reg [3:0]temp;

assign rrand = temp[3];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        temp <= 4'b0010;
    end else begin
        temp <= {temp[2] ^ temp[1], temp[3:1]};
    end
end

endmodule