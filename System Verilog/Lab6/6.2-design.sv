class calculator;

  // Constructor
  function new();
    $display("Calculator object created!");
  endfunction

  // addition
  task add(real a, real b,ref real res);
    res = a + b;
  endtask

  // subtraction
  task sub(real a, real b,ref real res);
        res = a - b;
  endtask

  // division
  task div(real a, real b,ref real res);
    if (b != 0)
      res =  a / b;
    else begin
      $display("Error: Division by zero!");
        res = 0;
    end
  endtask

  // multiplication
  task multi(real a, real b, ref real res);
    res = a * b;
  endtask
  
  // calculate power (a^b)
static task power(real base, real exponent, ref real res );
  res = (base ** exponent);
endtask

endclass