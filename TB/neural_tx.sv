`ifndef NEURAL_TX_SV
`define NEURAL_TX_SV

class neural_tx extends uvm_sequence_item;
`uvm_object_utils(neural_tx)

    function new(string name = "neural_tx");
        super.new(name);
    endfunction

    rand logic signed [7:0] input_data [4];
    logic signed [15:0] expected_output [2];
    logic signed [15:0] actual_output [2];
    bit compare_result;

    constraint input_range_c{
        foreach (input_data[i]) input_data[i] inside {[-128:127]};
    }

    constraint not_all_zero_c{
        input_data != `{default: 0};
    }
    
endclass
`endif
