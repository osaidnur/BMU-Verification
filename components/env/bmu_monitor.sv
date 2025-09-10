class bmu_monitor extends uvm_monitor;

`uvm_component_utils(bmu_monitor)

virtual bmu_interface vif;
uvm_analysis_port#(bmu_sequence_item) port;
bmu_sequence_item packet;

function new(string name = "bmu_monitor", uvm_component parent);
  super.new(name, parent);
  port = new("monitor_port",this);
  packet = new();
endfunction: new

function void build_phase(uvm_phase phase); 
    super.build_phase(phase);
    if(!uvm_config_db#(virtual bmu_interface) :: get(this, "", "vif", vif)) 
    `uvm_fatal(get_type_name(), "Not set at top level");
endfunction

task run_phase(uvm_phase phase);
    forever begin
        // @(posedge vif.driver_mod.clk); //-> sample directly at clock edge
        @(vif.monitor_cb);
        // #20 ;  // Small delay to avoid race conditions, but stay within same clock cycle
        packet.a_in = vif.monitor_cb.a_in;
        packet.b_in = vif.monitor_cb.b_in;
        packet.rst_l = vif.monitor_cb.rst_l;
        packet.scan_mode = vif.monitor_cb.scan_mode;
        packet.valid_in = vif.monitor_cb.valid_in;
        packet.csr_ren_in = vif.monitor_cb.csr_ren_in;
        packet.csr_rddata_in = vif.monitor_cb.csr_rddata_in;
        packet.ap = vif.monitor_cb.ap;
        packet.result_ff = vif.monitor_cb.result_ff;
        packet.error = vif.monitor_cb.error;

        `uvm_info("Monitor", $sformatf("the signals received from the DUT are: A = %d | B = %d | scan_mode= %b | valid_in = %b | csr_ren_in= %b | csr_rddata_in = %d | ap= %p | result_ff= %d | error= %b", packet.a_in, packet.b_in, packet.scan_mode, packet.valid_in, packet.csr_ren_in, packet.csr_rddata_in, packet.ap, packet.result_ff, packet.error), UVM_HIGH);
        
        // packet.print();
        port.write(packet);
    end
endtask
endclass