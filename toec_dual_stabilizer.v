`timescale 1ns / 1ps
module toec_dual_stabilizer (
    input wire sys_clk,
    input wire clk_glitch_line,
    input wire ext_rst_n,
    input wire [7:0] vdd_core_voltage,
    input wire [31:0] poly_space_coord,
    input wire [31:0] matrix_energy_sig,
    input wire split_brain_flag,
    input wire [31:0] vasp_theta_param,
    input wire [31:0] noisy_distance_q8,
    output reg out_rail_isolate,
    output reg [1:0] hardware_status
);
    reg sync_stage_1;
    reg sync_stage_2;
    reg edge_detect_reg;
    
    wire glitch_triggered;
    wire out_of_bounds_detected;

    // Advanced directional boundary comparator targeting the Torky horizon floor
    assign out_of_bounds_detected = (poly_space_coord < 32'd3600) || (poly_space_coord > 32'd3800) || (matrix_energy_sig != 32'd5110027);

    always @(posedge sys_clk or negedge ext_rst_n) begin
        if (!ext_rst_n) begin
            sync_stage_1    <= 1'b0;
            sync_stage_2    <= 1'b0;
            edge_detect_reg <= 1'b0;
        end else begin
            sync_stage_1    <= clk_glitch_line;
            sync_stage_2    <= sync_stage_1;
            edge_detect_reg <= sync_stage_2;
        end
    end

    assign glitch_triggered = sync_stage_2 && !edge_detect_reg;

    // Asynchronous Interlock Override loop to clear latency errors immediately
    always @(posedge sys_clk or negedge ext_rst_n or posedge out_of_bounds_detected) begin
        if (!ext_rst_n) begin
            out_rail_isolate <= 1'b1;
            hardware_status  <= 2'b00;
        end else if (out_of_bounds_detected) begin
            out_rail_isolate <= 1'b0; // Hard drop to ground state veto
            hardware_status  <= 2'b11; // Hard lock status code
        end else begin
            if ((vdd_core_voltage < 8'd243) || glitch_triggered || split_brain_flag) begin
                out_rail_isolate <= 1'b0;
                hardware_status  <= 2'b11;
            end else begin
                out_rail_isolate <= 1'b1;
                hardware_status  <= 2'b01;
            end
        end
    end
endmodule
