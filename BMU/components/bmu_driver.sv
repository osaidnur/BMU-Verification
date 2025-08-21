class bmu_driver extends uvm_driver#(bmu_sequence_item); 

`uvm_component_utils(bmu_driver)

function new(string name = "bmu_driver", uvm_component parent);
  super.new(name, parent);
endfunction: new

virtual bmu_interface vif;

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual bmu_interface) :: get(this, "", "vif", vif))
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
  vif.driver_cb.a_in <= req.a_in;
  vif.driver_cb.b_in <= req.b_in;
  vif.driver_cb.ap <= req.ap;
  vif.driver_cb.scan_mode <= req.scan_mode;
  vif.driver_cb.valid_in <= req.valid_in;
  vif.driver_cb.csr_ren_in <= req.csr_ren_in;
  vif.driver_cb.csr_rddata_in <= req.csr_rddata_in;

endtask

endclass