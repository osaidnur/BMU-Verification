module tb_fulladd;
   reg [3:0] a;
   reg [3:0] b;
   reg c_in;
   wire [3:0] sum;
   wire c_out;

  FullAdder2 fa0 ( .ina(a),.inb(b),.carry_in (c_in),.carry_out (c_out),.sum_out (sum));

   initial begin
      a <= 0;
      b <= 0;
      c_in <= 0;
      $monitor ("a=%2d | b=%2d | c_in=%2d | sum=%2d | c_out=%2d\n---------------------------------------",
             a, b, c_in, sum, c_out);
      $display("=========================");
      $display("===== Test Overflow =====");
      $display("=========================");
      #10 a <= 4'b1111; b <= 4'b0001; c_in <= 1'b0;
      
      #10 a <= 4'b1111; b <= 4'b1111; c_in <= 1'b0;

      #10
      $display("=========================");
      $display("===== Random Tests ======");
      $display("=========================");
      repeat (10) begin
          #10 a <= $random; b <= $random; c_in <= $random;
      end
   
      
   end
endmodule