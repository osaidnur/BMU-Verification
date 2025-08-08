module testslsr;
  logic clk,reset,sl,sr,din;
  wire [7:0] Q;
  
  reg [7:0]  expected;

  int errors = 0;
  
  slsr dut (sl, sr, din, clk, reset,Q);

  // clock
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin

    sl = 0; sr = 0; din = 0; reset = 0;
    $display("Start ------\n");

    // reset signal
    reset = 1;
    @(posedge clk);
    expected = 8'b00000000;
    check();
    reset = 0;
    
    // shift right
    sr = 1; sl = 0 ;din = 1; 
    @(posedge clk);
    expected = 8'b10000000;
    check();
    

    // both sr and sl are 0
    sr = 0; sl = 0;
    
    @(posedge clk);
    expected = 8'b10000000; // Value should not change
    check();

    // shift left
    sl = 1; sr = 0; din = 1; 
    @(posedge clk);
    expected = 8'b00000001;
    check();

    
    // errors checking
    if (errors == 0) begin
      $display("All tests passed\n");
    end else begin
      $display("Found %d errors", errors);
    end

    $finish;
  end


  task check();
    if (Q == expected) begin
      $display("[PASS]: Output = %8b", Q);  
    end 

    else begin
      $display("[FAIL]: Output = %8b, Expected = %8b", Q , expected);
      errors ++;
    end
  endtask

endmodule
