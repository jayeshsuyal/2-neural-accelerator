`ifndef NEURAL_COV_SV
`define NEURAL_COV_SV

class neural_cov extends uvm_subscriber #(neural_tx);
    `uvm_component_utils(neural_cov)

    // Covergroup variables
    covergroup cg_input;
        // Cover each input's value distribution, for example 8-bit wide inputs
        coverpoint tx.input_data[0] {
            bins low = {0,1,2,3,4,5,6,7,8,9};
            bins mid = {[10:200]};
            bins high = {[201:255]};
        }
        coverpoint tx.input_data[1];
        coverpoint tx.input_data[2];
        coverpoint tx.input_data[3];
        // Cross inputs to check correlations
        cross input_data[0], input_data[1], input_data[2], input_data[3];
    endgroup

    covergroup cg_output;
        coverpoint tx.actual_output[0];
        coverpoint tx.actual_output[1];
        cross actual_output[0], actual_output[1];
    endgroup

    neural_tx tx; // Transaction handle

    function new(string name = "neural_cov", uvm_component parent = null);
        super.new(name, parent);
        cg_input = new;
        cg_output = new;
    endfunction

    virtual function void write(neural_tx tx);
        this.tx = tx;
        cg_input.sample();
        cg_output.sample();
    endfunction

endclass : neural_cov

`endif
