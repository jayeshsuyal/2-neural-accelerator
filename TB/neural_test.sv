`ifndef NEURAL_TEST_SV
`define NEURAL_TEST_SV

class neural_test extends uvm_test;
    `uvm_component_utils(neural_test)

    neural_env env;

    function new(string name = "neural_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = neural_env::type_id::create("env", this);

        // Set agent to active
        uvm_config_db#(uvm_active_passive_e)::set(this, "env.agent", "is_active", UVM_ACTIVE);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        relu_negative_seq seq = relu_negative_seq::type_id::create("seq");
        seq.start(env.agent.seqr);
    endtask

endclass
`endif