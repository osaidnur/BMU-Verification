module calculator_tb;
real expected ;
real sum, difference, product, quotient, power_result;
calculator calc;

initial begin
    // Initialize calculator
    calc = new();
    
    // Basic
    // Test addition
    sum = calc.add(5.0, 3.0);
    expected = 8.0;
    check(sum);
    
    // Test subtraction
    difference = calc.sub(5.0, 3.0);
    expected = 2.0;
    check(difference);
    
    // Test multiplication
    product = calc.multi(5.0, 3.0);
    expected = 15.0;
    check(product);
    
    // Test division
    quotient = calc.div(5.0, 3.0);
    expected = 5.0/3.0;
    check(quotient);
    
    // Test division by zero
    quotient = calc.div(5.0, 0);
    
    // Test power function
    power_result = calculator::power(2.0, 3.0);
    expected = 8.0;
    check(power_result);

    // Test power function with negative exponent
    power_result = calculator::power(2.0, -3.0);
    expected = 0.125;
    check(power_result);

    // Test power function with zero exponent
    power_result = calculator::power(2.0, 0.0);
    expected = 1.0;
    check(power_result);

    // addition with real numbers
    sum = calc.add(2.6, 3.9);
    expected = 6.5;
    check(sum);

    // subtraction with real numbers
    difference = calc.sub(5.5, 2.2);
    expected = 3.3;
    check(difference);

    // multiplication with real numbers
    product = calc.multi(4.5, 2.0);
    expected = 9.0;
    check(product);

    // division with real numbers
    quotient = calc.div(7.5, 2.5);
    expected = 3.0;
    check(quotient);
    

end

task check(real actual);
    if (expected !== actual) begin
      $display("[Fail]: expected %0.3f, got %0.3f", expected, actual);
    end else begin
      $display("[Pass]: expected %0.3f, got %0.3f", expected, actual);
    end
endtask

endmodule