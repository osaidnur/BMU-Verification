module test_reg2;

logic [7:0] expected;
shiftLeftRegister leftshift;
shiftRightRegister rightshift;

initial begin
    // test leftshift - initialization
    leftshift = new();
    expected = 8'b0;
    check(leftshift.get_data());
    
    // initialize with a value
    leftshift = new(8'h11);
    expected = 8'h11;
    check(leftshift.get_data());
    
    // test shift left
    leftshift.shift_left();
    expected = 8'h22;
    check(leftshift.get_data());

    // test load and shift left
    // load function is inherited from Register parent class
    leftshift.load(8'hFF);
    leftshift.shift_left();
    expected = 8'hFE;
    check(leftshift.get_data());

    // test rightshift - initialization
    rightshift = new(8'h88);
    expected = 8'h88;
    check(rightshift.get_data());

    // test shift right
    rightshift.shift_right();
    expected = 8'h44;
    check(rightshift.get_data());


end

task check(logic [7:0] res);
    if (res !== expected) begin
        $display("[Fail]: expected %h, got %h", expected, res);
    end else begin
        $display("[Pass]: got %h as expected", res);
    end
endtask



endmodule