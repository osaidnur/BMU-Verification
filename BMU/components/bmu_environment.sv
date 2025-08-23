class bmu_environment extends uvm_env; 

`uvm_component_utils(bmu_environment)

bmu_agent agent;
bmu_scoreboard scoreboard;
// bmu_subscriber subscriber;

function new(string name,uvm_component parent); 
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase); 
    super.build_phase(phase); 
    agent = bmu_agent::type_id::create("agent",this);
    scoreboard = bmu_scoreboard::type_id::create("scoreboard",this); 
    // subscriber = bmu_subscriber::type_id::create("subscriber",this); 
endfunction 

function void connect_phase(uvm_phase phase);
    agent.monitor.port.connect(scoreboard.exp);
    // agent.monitor.port.connect(subscriber.analysis_export);
endfunction

endclass: bmu_environment