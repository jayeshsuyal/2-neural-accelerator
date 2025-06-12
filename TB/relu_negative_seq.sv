`ifndef RELU_NEGATIVE_SEQ_SV
`define RELU_NEGATIVE_SEQ_SV
`include "neural_base_seq.sv"

class relu_negative_seq extends neural_base_seq;
`uvm_object_utils(relu_negative_seq)

    function new(string name = "relu_negative_seq");
        super.new(name);
    endfunction

    virtual task body();
        neural_tx t = neural_tx::type_id :: create("t");
        start_item(t);
        
        assert (t.randomize() with {
            foreach (t.input_data[i]) t.input_data[i] < 0;
        });
        finish_item(t);
        `uvm_info(get_name(), "ReLu Negative sequence Executed", UVM_MEDIUM);        
    endtask     
endclass
`endif