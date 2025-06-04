module neural_net_2layer (
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   input_valid,
    input  logic signed [7:0]      input_data[4],   // 4 input neurons
    output logic                   output_valid,
    output logic signed [15:0]     output_data[2]   // 2 output neurons
);

    // === Hardcoded Weights and Biases ===

    // Layer 1 Weights: 4x4 matrix (Input → Hidden Layer)
    logic signed [7:0] W1[4][4] = '{
        '{8'd1, 8'd2, 8'd1, 8'd0},
        '{8'd0, 8'd1, 8'd2, 8'd1},
        '{8'd1, 8'd0, 8'd1, 8'd2},
        '{8'd2, 8'd1, 8'd0, 8'd1}
    };

    // Layer 1 Biases
    logic signed [7:0] B1[4] = '{8'd1, 8'd1, 8'd1, 8'd1};

    // Layer 2 Weights: 4x2 matrix (Hidden → Output Layer)
    logic signed [7:0] W2[4][2] = '{
        '{8'd1, 8'd0},
        '{8'd0, 8'd1},
        '{8'd1, 8'd1},
        '{8'd0, 8'd1}
    };

    // Layer 2 Biases
    logic signed [7:0] B2[2] = '{8'd0, 8'd0};

    // === Internal Signals ===
    logic signed [15:0] layer1_out[4];
    logic signed [15:0] layer2_out[2];
    logic               processing;

    // === ReLU Activation Function ===
    function logic signed [15:0] relu(input logic signed [15:0] val);
        return (val > 0) ? val : 16'sd0;
    endfunction

    // === Main Inference Logic ===
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            output_valid <= 0;
        end else begin
            output_valid <= 0;
            if (input_valid) begin
                // --- Layer 1: Input × W1 + B1, then ReLU ---
                for (int i = 0; i < 4; i++) begin
                    layer1_out[i] = B1[i];
                    for (int j = 0; j < 4; j++) begin
                        layer1_out[i] += input_data[j] * W1[j][i];
                    end
                    layer1_out[i] = relu(layer1_out[i]);
                end

                // --- Layer 2: Hidden × W2 + B2 (No activation) ---
                for (int i = 0; i < 2; i++) begin
                    layer2_out[i] = B2[i];
                    for (int j = 0; j < 4; j++) begin
                        layer2_out[i] += layer1_out[j] * W2[j][i];
                    end
                    output_data[i] <= layer2_out[i];
                end
                output_valid <= 1;
            end
        end
    end

endmodule