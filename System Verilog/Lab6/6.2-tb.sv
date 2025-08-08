module calculator_tb;
real expected ;
real sum, difference, product, quotient, power_result;
calculator calc;

initial begin
    
    // Initialize calculator
    calc = new();
    
    // Basic
    // Test addition
    calc.add(5.0, 3.0,sum);
    expected = 8.0;
    check(sum);
    
    // Test subtraction
    calc.sub(5.0, 3.0,difference);
    expected = 2.0;
    check(difference);
    
    // Test multiplication
    calc.multi(5.0, 3.0,product);
    expected = 15.0;
    check(product);
    
    // Test division
    calc.div(5.0, 3.0,quotient);
    expected = 5.0/3.0;
    check(quotient);
    
    // Test division by zero
    calc.div(5.0, 0,quotient);
    
    // Test power function
    calculator::power(2.0, 3.0,power_result);
    expected = 8.0;
    check(power_result);

    // Test power function with negative exponent
    calculator::power(2.0, -3.0,power_result);
    expected = 0.125;
    check(power_result);

    // Test power function with zero exponent
    calculator::power(2.0, 0.0,power_result);
    expected = 1.0;
    check(power_result);

    // addition with real numbers
    calc.add(2.6, 3.9,sum);
    expected = 6.5;
    check(sum);

    // subtraction with real numbers
    calc.sub(5.5, 2.2,difference);
    expected = 3.3;
    check(difference);

    // multiplication with real numbers
    calc.multi(4.5, 2.0,product);
    expected = 9.0;
    check(product);

    // division with real numbers
    calc.div(7.5, 2.5,quotient);
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