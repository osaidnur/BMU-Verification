class alu_agent extends uvm_agent; 
`uvm_component_utils(alu_agent)
alu_driver driver;
alu_sequencer sequencer;
alu_monitor monitor;

function new(string name = "alu_agent", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(get_is_active() == UVM_ACTIVE) begin 
  sequencer = alu_sequencer::type_id::create("alu_sequencer",this); 
  driver = alu_driver::type_id::create("alu_driver",this); 
  end 
  monitor = alu_monitor::type_id::create("alu_monitor",this); 
endfunction
  
function void connect_phase (uvm_phase phase); 
  super.connect_phase(phase); 
  if(get_is_active() == UVM_ACTIVE)begin
    driver.seq_item_port.connect(sequencer.seq_item_export); 
  end
endfunction
endclass