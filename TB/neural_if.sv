`ifndef NEURAL_IF_SV
`define NEURAL_IF_SV

interface neural_if(input logic clk);
    
    logic rst; 
    logic input_valid;
    logic signed [7:0] input_data[4];
    logic output_valid;
    logic signed [15:0] output_data[2];

    clocking drv_cb @(posedge clk);
        output input_valid;
        output input_data;
    endclocking 

    clocking mon_cb @(posedge clk);
        input input_valid;
        input input_data;
        input output_valid;
        input output_data;
    endclocking

    modport DRV(clocking drv_cb, input rst);
    modport MON (clocking mon_cb, input rst);
    modport DUT (input clk, rst, input_valid,input_data, output_valid, output_data);

endinterface
`endif

