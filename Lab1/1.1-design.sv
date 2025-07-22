module slsr(sl, sr, din, clk, reset,Q); 
  input sl, sr, din, clk, reset; 
  output [7:0] Q;

  reg [7:0] temp;

  assign Q = temp;
  
  always @(posedge clk, reset)begin
    
    // for reset signal
    if(reset)begin
      temp <= 8'b0 ;
    end
    
    else begin
      
      // cover the 1 1 case
      if(sl && sr) begin
        temp <= temp; // No change
      end

      // shift left
      else if(sl)begin
        temp <= {temp[6:0] , din};
      end

      // shift right
      else if(sr)begin
        temp<= {din , temp[7:1]};
      end
      
    end
    
  end
  
endmodule

