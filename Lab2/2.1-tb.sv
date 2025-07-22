module test_register;
logic clk, reset, sel, wr;
logic [1:0] addr;
logic [15:0] rdata, wdata;

register_desgin dut(clk, reset, sel, wr, addr, rdata, wdata);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    sel = 0;
    wr = 0;
    addr = 0;
    wdata = 16'h0000;
    $display("Reset...");

    // release reset
    @(posedge clk);
    reset = 0;
    sel = 1; wr = 0; addr = 2'b00;
    @(posedge clk);
    if(rdata !== 16'h0000) begin
        $display("[Fail]: Expected rdata = 16'h0000, got %h", rdata);
    end else begin
        $display("[Pass]: Initial read after reset from register 0: %h", rdata);
    end

    // write to register 0
    sel = 1; wr = 1; addr = 2'b00; wdata = 16'h1234;
    @(posedge clk);
    
    // read from register 0
    wr = 0; 
    @(posedge clk);
    if (rdata !== 16'h1234) begin
        $display("[Fail]: Expected rdata = 16'h1234, got %h", rdata);
    end else begin
        $display("[Pass]: Read from register 0: %h", rdata);
    end

    // Write to register 1
    wr = 1; addr = 2'b01; wdata = 16'h5678;
    @(posedge clk);

    // Read from register 1
    wr = 0; addr = 2'b01;
    @(posedge clk);
    if (rdata !== 16'h5678) begin
        $display("[Fail]: Expected rdata = 16'h5678, got %h", rdata);
    end else begin
        $display("[Pass]: Read from register 1: %h", rdata);
    end


    // put sel to 0 
    sel = 0; wr = 0; addr = 2'b00;
    
    // Read from register 0 again
    @(posedge clk);
    if (rdata !== 16'h5678) begin
        $display("[Fail]: Expected rdata = 16'h5678, got %h", rdata);
    end else begin
        $display("[Pass]: Read from register 0 after sel = 0: %h", rdata);
    end

    $finish;
end

endmodule