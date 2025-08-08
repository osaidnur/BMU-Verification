module FullAdder2(
  input [3:0] ina,
  [3:0] inb,
  carry_in, 
  output reg [3:0] sum_out,
  output reg carry_out);
  
  always @( ina or inb or carry_in)
    begin
      {carry_out, sum_out} = ina + inb + carry_in;
    end
  
endmodule

 
  
  