class Register ;
logic [7:0] data;

function new(logic [7:0] value = 8'b0);
    data = value;
endfunction

function void load(logic [7:0] value);
    data = value;
endfunction

function logic [7:0] get_data();
    return data;
endfunction

endclass

class shiftLeftRegister extends Register;
    function new(logic [7:0] value = 8'b0);
        super.new(value); 
    endfunction
    
    function void shift_left();
        data = data << 1;
    endfunction
endclass


class shiftRightRegister extends Register;
    function new(logic [7:0] value = 8'b0);
        super.new(value);
    endfunction
    
    function void shift_right();
        this.data = this.data >> 1;
    endfunction
endclass