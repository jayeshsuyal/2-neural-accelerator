`ifndef NEURAL_ENV_SV
`define NEURAL_ENV_SV

class neural_env extends uvm_env;
    `uvm_component_utils(neural_env)

    neural_agent agent;
    neural_sco sco;
    neural_cov cov;

    function new(string name = "neural_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = neural_agent::type_id::create("agent", this);
        sco   = neural_sco::type_id::create("sco", this);
        cov   = neural_cov::type_id::create("cov", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.mon.send.connect(sco.recv);
        agent.mon.send.connect(cov.analysis_export);
    endfunction

endclass

`endif