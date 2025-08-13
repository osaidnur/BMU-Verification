class alu_driver extends uvm_driver#(alu_sequence_item); 

`uvm_component_utils(alu_driver)

function new(string name = "alu_driver", uvm_component parent);
  super.new(name, parent);
endfunction: new

virtual alu_interface vif;

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_interface) :: get(this, "", "vif", vif))
    `uvm_fatal(get_type_name(), "Not set at top level"); 
endfunction

task run_phase(uvm_phase phase);
forever begin 
    seq_item_port.get_next_item(req);
    drive();
    `uvm_info(get_type_name, $sformatf("Driver: signals driven to the DUT are: A = %0d,%0d, Opcode = %h", req.A, req.B,req.opcode), UVM_HIGH);        
    seq_item_port.item_done();
end
endtask

task drive(); 
  @(vif.driver_cb);
  vif.driver_cb.A <= req.A;
  vif.driver_cb.B <= req.B;
  vif.driver_cb.opcode <= req.opcode;
endtask

endclass