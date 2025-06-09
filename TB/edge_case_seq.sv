`ifndef EDGE_CASE_SEQ_SV
`define EDGE_CASE_SEQ_SV
`include "neural_base_seq.sv"

class edge_case_seq extends neural_base_seq;
  `uvm_object_utils(edge_case_seq)

    function new(string name = "edge_case_seq");
        super.new(name);
    endfunction

    virtual task body();
        neural_tx t = neural_tx :: type_id :: create("t");

        start_item(t);
        assert (t.randomize() with {    
            
            foreach(input_data[i])
            input_data[i] inside {-128, -1, 0, 1, 127};

        });       
        finish_item(t);
    endtask 
endclass

`endif