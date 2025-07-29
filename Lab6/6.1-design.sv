class calculator;

  // Constructor
  function new();
    $display("Calculator object created!");
  endfunction

  // addition
  function real add(real a, real b);
    return a + b;
  endfunction

  // subtraction
  function real sub(real a, real b);
    return a - b;
  endfunction

  // division
  function real div(real a, real b);
    if (b != 0)
      return a / b;
    else begin
      $display("Error: Division by zero!");
      return 0;
    end
  endfunction

  // multiplication
  function real multi(real a, real b);
  return a * b;
  endfunction
  
  // calculate power (a^b)
static function real power(real base, real exponent);
  return (base ** exponent);
endfunction

endclass