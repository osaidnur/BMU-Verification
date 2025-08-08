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