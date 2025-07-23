module test; 
reg a, b, c, d; 
wire e; 
and and1 (e, a, b, c); 

initial begin 
    $monitor("%d d=%b,e=%b", $stime, d, e); 
    assign d = a & b & c; 
    a = 1; 
    b = 0; 
    c = 1; 
    #10; 
    force d = (a | b | c); 
    force e = (a | b | c); 
    #10 $stop; 
    release d; 
    release e; 
    #10 $finish; 
end 

endmodule

/*
My comment on the result:

- in this code, both 'd' and 'e' are representing the same logic , which is and gate ,
  but 'd' is implemented using the assign keyword (continuous assignment), while 'e' is connected
  using a 3-input and gate .

- After 10 time units , both signals 'd' and 'e' are forced to be the result of the logical OR 
  operation on 'a', 'b', and 'c' using the keyword 'force' , and this overrides their previous connections.

- so,the output after forcing will be the result of the OR operation which is 1 , while the original 
  AND operation would have resulted in 0.

- After release, the signals 'd' and 'e' will return to their original connections, but the simulation 
  will stop after the release, so we will not see the original AND operation result again.
*/