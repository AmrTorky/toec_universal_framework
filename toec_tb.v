`timescale 1ns / 1ps

module toec_tb;
    reg sys_clk;
    reg clk_glitch_line;
    reg ext_rst_n;
    reg [7:0] vdd_core_voltage;
    reg [31:0] poly_space_coord;
    reg [31:0] matrix_energy_sig;
    reg split_brain_flag;
    reg [31:0] vasp_theta_param;
    reg [31:0] noisy_distance_q8;

    wire out_rail_isolate;
    wire [1:0] hardware_status;

    toec_dual_stabilizer dut (
        .sys_clk(sys_clk),
        .clk_glitch_line(clk_glitch_line),
        .ext_rst_n(ext_rst_n),
        .vdd_core_voltage(vdd_core_voltage),
        .poly_space_coord(poly_space_coord),
        .matrix_energy_sig(matrix_energy_sig),
        .split_brain_flag(split_brain_flag),
        .vasp_theta_param(vasp_theta_param),
        .noisy_distance_q8(noisy_distance_q8),
        .out_rail_isolate(out_rail_isolate),
        .hardware_status(hardware_status)
    );

    always #10 sys_clk = ~sys_clk;

    initial begin
        sys_clk = 0;
        clk_glitch_line = 0;
        ext_rst_n = 0;
        vdd_core_voltage = 8'd250;
        poly_space_coord = 32'd1000;
        matrix_energy_sig = 32'd1000;
        split_brain_flag = 0;
        vasp_theta_param = 32'b0;
        noisy_distance_q8 = 32'd5;

        #25 ext_rst_n = 1;
        #20 poly_space_coord = 32'd3670; matrix_energy_sig = 32'd5110027;
        #40;

        $display("[STATUS]: Injecting asynchronous glitch pulse into active timing setup window.");
        @(posedge sys_clk);
        #1.5 clk_glitch_line = 1;
        #5 clk_glitch_line = 0;

        @(posedge sys_clk);
        $display("[EDGE 1]: Sync Stage 1 catches glitch. Isolate Rail = %b", out_rail_isolate);
        
        @(posedge sys_clk);
        $display("[EDGE 2]: Dual-Stage Barrier synchronized. Isolate Rail = %b", out_rail_isolate);
        
        @(posedge sys_clk);
        #1;
        $display("[EDGE 3]: Hard hardware veto finalized. Isolate Rail = %b", out_rail_isolate);
        $display("          Systemic Ledger Status Bits = %b", hardware_status);

        if (out_rail_isolate == 1'b0 && hardware_status == 2'b11) begin
            $display("========================================================================================");
            $display("RESPONSE LATENCY TIMELINE CHECK: [PASSED]");
            $display(" -> METASTABILITY OVERHEAD RESOLVED: 3 Clock edges dropped asynchronous violation.");
            $display("========================================================================================");
        end else begin
            $display("RESPONSE LATENCY TIMELINE CHECK: [FAILED]");
        end
        $finish;
    end
endmodule
