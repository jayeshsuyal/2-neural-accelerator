`ifndef NEURAL_DRV_SV
`define NEURAL_DRV_SV

class neural_drv extends uvm_driver #(neural_tx);
    `uvm_component_utils(neural_drv)

    virtual neural_if vif;

    function new(string name = "neural_drv", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual neural_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Interface not set for Driver");
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        neural_tx req;
        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info(get_type_name(), $sformatf("Driving Transaction %p", req), UVM_MEDIUM);

            driver_input(req);
            capture_output(req);

            seq_item_port.item_done();
        end
    endtask

    task driver_input(neural_tx tx);
        @(posedge vif.clk)
        begin
            vif.input_valid <= 1;
            for (int i = 0; i < 4; i++) begin
                vif.input_data[i] <= tx.input_data[i];
            end
        end

        @(posedge vif.clk);
        vif.input_valid <= 0;
    endtask

    task capture_output(neural_tx tx);
        wait (vif.output_valid == 1);
        @(posedge vif.clk);
        for (int i = 0; i < 2; i++) begin
            tx.actual_output[i] = vif.output_data[i];
        end
        tx.compare_result = 0;
    endtask

endclass: neural_drv

`endif
