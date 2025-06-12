`ifndef NEURAL_SCO_SV
`define NEURAL_SCO_SV

class neural_sco extends uvm_scoreboard;
    `uvm_component_utils(neural_sco)

    uvm_analysis_imp #(neural_tx, neural_sco) recv;
    int pass_count = 0;
    int fail_count = 0;

    function new(string name = "neural_sco", uvm_component parent);
        super.new(name, parent);        
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv", this); 
    endfunction

    //write logic
    virtual function void write(neural_tx tx);
        bit [7:0] relu_out[4];

        foreach (tx.input_data[i])
            relu_out[i] = (tx.input_data[i] < 0) ? 0 : tx.input_data[i];

        tx.expected_output[0] = relu_out[0] + relu_out[1];
        tx.expected_output[1] = relu_out[2] + relu_out[3];

        if (tx.actual_output[0] !== tx.expected_output[0] ||
            tx.actual_output[1] !== tx.expected_output[1]) begin
            `uvm_error("SCO", $sformatf("Data Mismatch, expected: %p and got: %p",
                                        tx.expected_output, tx.actual_output));
            fail_count++;
        end else begin
            `uvm_info("SCO", "Test Pass: DATA match", UVM_LOW);
            pass_count++;
        end
    endfunction

    //implementation of report phase
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCO", $sformatf("Test Summary: Pass: %0d, Fail: %0d",
                                   pass_count, fail_count), UVM_NONE);

        if (fail_count > 0) begin
            `uvm_error("SCO", "TEST FAILED: One or more mismatches detected.")
        end else begin
            `uvm_info("SCO", "TEST PASSED: All transactions matched.", UVM_NONE)
        end
    endfunction

endclass

`endif
