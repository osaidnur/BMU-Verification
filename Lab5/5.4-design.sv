class Register #(parameter int DATA_WIDTH = 8 );

logic [DATA_WIDTH-1:0] data;
static int instance_count = 0;
function new(logic [DATA_WIDTH-1:0] value = '0);
    data = value;
    instance_count++;
endfunction

function void load(logic [DATA_WIDTH-1:0] value);
    data = value;
endfunction

function logic [DATA_WIDTH-1:0] get_data();
    return data;
endfunction

function static int get_instance_count();
    return instance_count;
endfunction

endclass

// when inheriting from Register, specify the DATA_WIDTH parameter
class shiftLeftRegister #(parameter int DATA_WIDTH = 8 ) extends Register #(DATA_WIDTH);
    function new(logic [DATA_WIDTH-1:0] value = '0);
        super.new(value); 
    endfunction
    
    function void shift_left();
        data = data << 1;
    endfunction
endclass


class shiftRightRegister #(parameter int DATA_WIDTH = 8 ) extends Register #(DATA_WIDTH);
    function new(logic [DATA_WIDTH-1:0] value = '0);
        super.new(value);
    endfunction
    
    function void shift_right();
        this.data = this.data >> 1;
    endfunction
endclass