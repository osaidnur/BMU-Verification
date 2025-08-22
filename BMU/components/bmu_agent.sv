class bmu_agent extends uvm_agent; 
`uvm_component_utils(bmu_agent)

bmu_driver driver;
bmu_sequencer sequencer;
bmu_monitor monitor;

function new(string name = "bmu_agent", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(get_is_active() == UVM_ACTIVE) begin 
  sequencer = bmu_sequencer::type_id::create("bmu_sequencer",this); 
  driver = bmu_driver::type_id::create("bmu_driver",this); 
  end 
  monitor = bmu_monitor::type_id::create("bmu_monitor",this); 
endfunction
  
function void connect_phase (uvm_phase phase); 
  super.connect_phase(phase); 
  if(get_is_active() == UVM_ACTIVE)begin
    driver.seq_item_port.connect(sequencer.seq_item_export); 
  end
endfunction
endclass