class bmu_sequencer extends uvm_sequencer #(bmu_sequence_item);

`uvm_component_utils(bmu_sequencer)

function new(string name = "bmu_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction: new

endclass: bmu_sequencer