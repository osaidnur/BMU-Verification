module test_dff;
    logic clk, clear, preset, d;
    wire logic q;
    logic expected;

    // instantiate the DFF 
    DFF uut (
        .clk(clk),
        .clear(clear),
        .d(d),
        .preset(preset),
        .q(q)
    );

    initial begin
        forever begin
            #10 clk = ~clk; 
        end
    end


    initial begin
        
        clk = 0;
        preset = 0;
        clear = 0;
        d = 0;

        // test the undefined state 
        $display("Testing undefined state...");
        @(posedge clk);
        expected = 1'bx;
        check();

        // test preset
        $display("Testing preset...");
        preset = 1;
        @(posedge clk);
        expected = 1'b0; 
        check();    

        // test clear
        $display("Testing clear...");
        preset = 0; // reset preset
        clear = 1;
        @(posedge clk);
        expected = 1'b1; 
        check();
        

        // test normal operation
        $display("Testing normal operation (d=1)...");
        preset = 1;
        clear =1 ;
        d = 1;
        @(posedge clk);
        expected = 1'b1; 
        check();

        $display("Testing normal operation (d=0)...");
        d = 0;
        @(posedge clk);
        expected = 1'b0; 
        check();

        // Finish simulation
        $finish;
    end

    task check();
        if (q !== expected) begin
            $display("  [Fail]: Expected %b, got %b", expected, q);
        end else begin
            $display("  [Pass]: got %b", q);
        end
    endtask

endmodule