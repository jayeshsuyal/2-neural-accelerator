`ifndef NEURAL_MON_SV
`define NEURAL_MON_SV

class neural_mon extends uvm_monitor;
    `uvm_component_utils(neural_mon)

    uvm_analysis_port #(neural_tx) send;
    virtual neural_if vif;

    function new(string name = "neural_mon", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);

        if (!uvm_config_db#(virtual neural_if)::get(this, "", "vif", vif)) begin
            `uvm_error("MON", "Failed to get interface from config DB");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            neural_tx tx = neural_tx::type_id::create("tx", this);

            // Capture input
            wait (vif.input_valid == 1);
            @(posedge vif.clk);
            for (int i = 0; i < 4; i++) begin
                tx.input_data[i] = vif.input_data[i];
            end

            // Capture output
            wait (vif.output_valid == 1);
            @(posedge vif.clk);
            for (int i = 0; i < 2; i++) begin
                tx.actual_output[i] = vif.output_data[i];
            end

            // Send transaction to scoreboard/coverage
            send.write(tx);

            `uvm_info("MON", $sformatf("Captured Tx: input: %0p, output: %0p",
                tx.input_data, tx.actual_output), UVM_NONE)
        end
    endtask
endclass
`endif
