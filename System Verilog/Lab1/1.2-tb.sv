module testprbs ;
logic clk, reset;
wire rrand;
reg [3:0] expected  ;
int errors = 0;

prbs dut (rrand, clk, reset);
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    reset = 1;
    @(posedge clk);
    expected = 4'b0010;
    check();

    reset = 0;

    repeat (10) begin
        
        @(posedge clk);
        expected = {expected[1] ^ expected[2], expected[3:1]};
        check();
    end

    // Check for errors
    if (errors == 0) begin
        $display("All tests passed\n");
    end else begin
        $display("Found %d errors", errors);
    end
    $finish;
end


task check;
    if (rrand == expected[3]) begin
        $display("[PASS]: output = %b ", rrand);
    end
    
    else begin
        $display("[FAIL]: Output = %b , Expected = %b ",rrand, expected[3]);
        errors++;
    end
endtask
endmodule 