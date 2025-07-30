module test_reg2;
localparam DATA_WIDTH = 16;

logic [DATA_WIDTH-1:0] expected;
shiftLeftRegister #(DATA_WIDTH) leftshift ;
shiftRightRegister #(DATA_WIDTH) rightshift ;

initial begin
    // test leftshift - initialization
    //$display("***** There is %0d instances of Register class *****", leftshift.get_instance_count());
    leftshift = new();
    expected = 16'b0;
    check(leftshift.get_data());
    //$display("***** There is %0d instances of Register class *****", leftshift.get_instance_count());

    // initialize with a value
    leftshift = new(16'h1111);
    expected = 16'h1111;
    check(leftshift.get_data());
    
    // test shift left
    leftshift.shift_left();
    expected = 16'h2222;
    check(leftshift.get_data());
    //$display("***** There is %0d instances of Register class *****", leftshift.get_instance_count());

    // test load and shift left
    // load function is inherited from Register parent class
    leftshift.load(16'h11FF);
    leftshift.shift_left();
    expected = 16'h23FE;
    check(leftshift.get_data());

    // test rightshift - initialization
    rightshift = new(16'h8888);
    expected = 16'h8888;
    check(rightshift.get_data());
    //$display("***** There is %0d instances of Register class *****", rightshift.get_instance_count());

    // test shift right
    rightshift.shift_right();
    expected = 16'h4444;
    check(rightshift.get_data());


end

task check(logic [DATA_WIDTH-1:0] res);
    if (res !== expected) begin
        $display("[Fail]: expected %h, got %h", expected, res);
    end else begin
        $display("[Pass]: got %h as expected", res);
    end
endtask



endmodule