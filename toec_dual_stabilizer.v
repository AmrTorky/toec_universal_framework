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
    reg sync_ff1;
    reg sync_ff2;
    reg sync_ff3;
    reg glitch_edge_reg;
    wire glitch_event_pulse;
    wire physical_envelope_violation;

    assign physical_envelope_violation = (poly_space_coord < 32'd3600) || (poly_space_coord > 32'd3800) || (matrix_energy_sig != 32'd5110027);

    always @(posedge sys_clk or negedge ext_rst_n) begin
        if (!ext_rst_n) begin
            sync_ff1        <= 1'b0;
            sync_ff2        <= 1'b0;
            sync_ff3        <= 1'b0;
            glitch_edge_reg <= 1'b0;
        end else begin
            sync_ff1        <= clk_glitch_line;
            sync_ff2        <= sync_ff1;
            sync_ff3        <= sync_ff2;
            glitch_edge_reg <= sync_ff3;
        end
    end
    assign glitch_event_pulse = sync_ff3 && !glitch_edge_reg;

    always @(posedge sys_clk or negedge ext_rst_n or posedge physical_envelope_violation) begin
        if (!ext_rst_n) begin
            out_rail_isolate <= 1'b1;
            hardware_status  <= 2'b00;
        end else if (physical_envelope_violation) begin
            out_rail_isolate <= 1'b0;
            hardware_status  <= 2'b11;
        end else begin
            if ((vdd_core_voltage < 8'd243) || glitch_event_pulse || split_brain_flag) begin
                out_rail_isolate <= 1'b0;
                hardware_status  <= 2'b11;
            end else begin
                out_rail_isolate <= 1'b1;
                hardware_status  <= 2'b01;
            end
        end
    end
endmodule
