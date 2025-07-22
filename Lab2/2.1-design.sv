module register_desgin(clk,reset,sel,wr,addr,rdata,wdata);
input logic [15:0] wdata ;
input logic clk, reset,sel,wr;
input logic [1:0] addr;
output logic [15:0] rdata ;

logic [15:0] mem [3:0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 4; i++) begin
                mem[i] <= 0;
            end
        rdata <= 0;
    end
    else if (wr && sel) begin
        mem[addr] <= wdata;
        rdata <= wdata;
    end
    else if (!wr && sel) begin
        rdata <= mem[addr];
    end
end
endmodule