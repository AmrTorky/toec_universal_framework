`timescale 1ns/1ps
module toec_tb;
reg sys_clk,clk_glitch_line,ext_rst_n;
reg [7:0] vdd_core_voltage;
reg [31:0] poly_space_coord,matrix_energy_sig;
reg split_brain_flag;
reg [31:0] vasp_theta_param,noisy_distance_q8;
wire out_rail_isolate;
wire [1:0] hardware_status;
toec_dual_stabilizer uut(.sys_clk(sys_clk),.clk_glitch_line(clk_glitch_line),.ext_rst_n(ext_rst_n),.vdd_core_voltage(vdd_core_voltage),.poly_space_coord(poly_space_coord),.matrix_energy_sig(matrix_energy_sig),.split_brain_flag(split_brain_flag),.vasp_theta_param(vasp_theta_param),.noisy_distance_q8(noisy_distance_q8),.out_rail_isolate(out_rail_isolate),.hardware_status(hardware_status));
always #5 sys_clk = ~sys_clk;
initial begin
sys_clk=0;clk_glitch_line=0;ext_rst_n=0;vdd_core_voltage=8'd250;poly_space_coord=32'd3700;matrix_energy_sig=32'd5110027;split_brain_flag=0;vasp_theta_param=0;noisy_distance_q8=0;
#20 ext_rst_n=1;
#50;
$display("[STATUS]: Injecting asynchronous glitch pulse into active timing setup window.");
clk_glitch_line=1;
#10 clk_glitch_line=0;
#60;
#10 poly_space_coord=32'd4000;
#5;
$finish;
end
endmodule
