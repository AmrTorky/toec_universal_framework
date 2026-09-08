// TOEC METASTABILITY-HARDENED COGNITIVE NEURAL SAFETY FABRIC
`timescale 1ns / 1ps

module toec_dual_stabilizer (
    input wire sys_clk,
    input wire clk_glitch_line,      // Asynchronous Glitch Input Vector
    input wire ext_rst_n,
    input wire [7:0] vdd_core_voltage,
    // Track A (Project 1 Consensus Data Bus)
    input wire [31:0] poly_space_coord,
    input wire [31:0] matrix_energy_sig,
    input wire split_brain_flag,
    // Track B (Project 2 / VASP Optimization Layer)
    input wire [31:0] vasp_theta_param,
    input wire [31:0] noisy_distance_q8,
    // Output Enforcement Rails
    output reg out_rail_isolate,
    output reg [1:0] hardware_status
);

    // Hardwired Torky Invariant Scaling Parameters
    localparam [31:0] LAMBDA_S = 32'd3670;
    localparam [31:0] LAMBDA_E = 32'd5110027;
    localparam [31:0] EPSILON_Q8 = 32'd4; 

    // Hardwired Cognitive NN Weights (toec_cognitive_nn.cpp)
    localparam signed [15:0] NN_W0 = 16'h14A2;
    localparam signed [15:0] NN_W1 = 16'hE5BD;
    localparam signed [15:0] DRIFT_THRESHOLD = 16'h2000;
    localparam [7:0] VDD_CRITICAL_MIN = 8'd243; 

    // Internal pipeline registers
    reg [63:0] lhs_cross_mult;
    reg [63:0] rhs_cross_mult;
    reg [31:0] denominator_sq;
    reg signed [31:0] neural_inference_score;

    // Dual-Stage Metastability Hardening Synchronizer Registers
    reg glitch_sync_stage1;
    reg glitch_sync_stage2;
    reg glitch_latch;

    always @(posedge sys_clk or negedge ext_rst_n) begin
        if (!ext_rst_n) begin
            glitch_sync_stage1 <= 1'b0;
            glitch_sync_stage2 <= 1'b0;
        end else begin
            glitch_sync_stage1 <= clk_glitch_line;
            glitch_sync_stage2 <= glitch_sync_stage1;
        end
    end

    // Edge Detector Latch Circuit
    always @(posedge sys_clk or negedge ext_rst_n) begin
        if (!ext_rst_n) begin
            glitch_latch <= 1'b0;
        end else if (glitch_sync_stage2) begin
            glitch_latch <= 1'b1;
        end
    end

    // Core Enforcement Logic Block
    always @(posedge sys_clk or negedge ext_rst_n) begin
        if (!ext_rst_n) begin
            out_rail_isolate       <= 1'b0;
            hardware_status        <= 2'b00;
            lhs_cross_mult         <= 64'b0;
            rhs_cross_mult         <= 64'b0;
            denominator_sq         <= 32'b0;
            neural_inference_score <= 32'b0;
        end else begin
            lhs_cross_mult <= poly_space_coord * LAMBDA_E;
            rhs_cross_mult <= matrix_energy_sig * LAMBDA_S;
            denominator_sq <= (noisy_distance_q8 * noisy_distance_q8) + EPSILON_Q8;
            neural_inference_score <= (poly_space_coord[15:0] * NN_W0) + (matrix_energy_sig[15:0] * NN_W1);

            // Integrated Multi-Vector Evaluation Loop
            if ((lhs_cross_mult != rhs_cross_mult) || 
                split_brain_flag || 
                (denominator_sq == 32'b0) || 
                glitch_latch ||
                (neural_inference_score > DRIFT_THRESHOLD) ||
                (vdd_core_voltage < VDD_CRITICAL_MIN)) begin
                
                out_rail_isolate <= 1'b0;       // HARDWARE VETO ACTIVE
                hardware_status  <= 2'b11;
            end else begin
                out_rail_isolate <= 1'b1;       // NOMINAL OPERATIONS
                hardware_status  <= 2'b01;
            end
        end
    end
endmodule
