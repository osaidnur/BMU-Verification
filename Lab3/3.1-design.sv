module FullAdder1(
  input [3:0] ina,
  [3:0] inb,
  carry_in, 
  output [3:0] sum_out,
  output carry_out);
  
  assign{carry_out, sum_out} = ina + inb + carry_in;
  
endmodule

 
  
  