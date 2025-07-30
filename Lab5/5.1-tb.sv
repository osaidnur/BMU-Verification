module test_reg ;
logic [7:0] expected;
Register my_reg;

initial begin
    my_reg = new();
    expected = 8'b0;
    check(my_reg.get_data());
    
    
    my_reg = new(8'h11);
    expected = 8'h11;
    check(my_reg.get_data());

    my_reg.load(8'hFC);
    expected = 8'hFC;
    check(my_reg.get_data());
end

task check(logic [7:0] res);
    if (res !== expected) begin
        $display("[Fail]: expected %h, got %h", expected, res);
    end else begin
        $display("[Pass]: got %h as expected", res);
    end
endtask

endmodule