`ifndef NEURAL_BASE_SEQ_SV
`define NEURAL_BASE_SEQ_SV
`include "neural_tx.sv"

class neural_base_seq extends uvm_sequence #(neural_tx);
    `uvm_object_utils(neural_base_seq)

    neural_tx t; // transaction handle

    function new(string name = "neural_base_seq");
        super.new(name);
    endfunction
    
    virtual task body();
        t = neural_tx::type_id::create("t");
        start_item(t);
        assert(t.randomize()) else
            `uvm_error("SEQ", "Randomization failed!");
        finish_item(t);
    endtask

endclass
`endif