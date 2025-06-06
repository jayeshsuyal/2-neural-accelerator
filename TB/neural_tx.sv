`ifndef NEURAL_TX_SV
`define NEURAL_TX_SV

class neural_tx extends uvm_sequence_item;

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
     (input_data [0] != 0) || (input_data [1] != 0) || (input_data [2] != 0) || (input_data [1] != 0); 
    }

  `uvm_object_utils_begin(neural_tx)
  `uvm_field_sarray_int (input_data, UVM_ALL_ON)
        `uvm_field_sarray_int(expected_output, UVM_ALL_ON)
        `uvm_field_sarray_int(actual_output, UVM_ALL_ON)
        `uvm_field_int(compare_result, UVM_ALL_ON)
    `uvm_object_utils_end    
endclass
`endif
