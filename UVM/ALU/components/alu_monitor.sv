class alu_monitor extends uvm_monitor; 
`uvm_component_utils(alu_monitor)
virtual alu_interface vif;
uvm_analysis_port#(alu_sequence_item) port;
alu_sequence_item packet;
function new(string name = "alu_monitor", uvm_component parent);
  super.new(name, parent);
  port = new("monitor_port",this);
  packet = new();
endfunction: new
function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    if(!uvm_config_db#(virtual alu_interface) :: get(this, "", "vif", vif)) 
    `uvm_fatal(get_type_name(), "Not set at top level"); 
endfunction
task run_phase(uvm_phase phase);
    forever begin
        @(vif.monitor_cb); 
        packet.A = vif.monitor_cb.A; 
        packet.B = vif.monitor_cb.B; 
        packet.opcode = vif.monitor_cb.opcode; 
        `uvm_info(get_type_name, $sformatf("[Monitor]: input signals sent to the DUT are: A = %0d, B = %0d, Opcode = %h", packet.A, packet.B, packet.opcode), UVM_HIGH); 
        packet.result = vif.monitor_cb.result;
        packet.error = vif.monitor_cb.error;
        `uvm_info(get_type_name, $sformatf("[Monitor]: the output signals received from the DUT are: Result = %d, Error = %b", packet.result, packet.error), UVM_HIGH);
        // packet.print();
        port.write(packet);
    end
endtask
endclass