`ifndef NEURAL_AGNT_SV
`define NEURAL_AGNT_SV

class neural_agnt extends uvm_agent;
`uvm_component_utils(neural_agnt)

    neural_drv drv;
    neural_mon mon;
    uvm_sequencer #(neural_tx) seqr;

    function new(string name = "neural_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(is_active == UVM_ACTIVE) begin
            seqr = uvm_sequencer#(neural_tx):: type_id:: create("seqr",this);
            drv = neural_drv:: type_id::create("drv",this);
        end
        mon = neural_mon:: type_id:: create("mon",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end

    endfunction

endclass : neural_agnt
`endif
// need to fix this class. adding the config for is_active

