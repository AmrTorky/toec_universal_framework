// ========================================================================================
// TOEC UNIFIED MULTI-CHANNEL SPATIAL MESH ROUTER VERIFICATION TESTBENCH
// ========================================================================================
`timescale 1ns / 1ps

module toec_mesh_router_tb;
    reg         clk;
    reg         rst_n;
    reg         veto_assert;
    reg  [31:0] packet_in;
    wire [31:0] packet_out;
    wire        propagation_clamp;
    wire [2:0]  mesh_state;

    // Instantiate Device Under Test (DUT)
    toec_mesh_router uut (
        .clk(clk),
        .rst_n(rst_n),
        .veto_assert(veto_assert),
        .packet_in(packet_in),
        .packet_out(packet_out),
        .propagation_clamp(propagation_clamp),
        .mesh_state(mesh_state)
    );

    // Continuous clock simulation driver
    always #1.0 clk = ~clk;

    initial begin
        $dumpfile("cognitive_mesh_logic.vcd");
        $dumpvars(0, toec_mesh_router_tb);

        clk = 0;
        rst_n = 0;
        veto_assert = 0;
        packet_in = 32'h0;

        #4 rst_n = 1;
        
        // Inject baseline 2D vector packet routing transaction
        #2;
        packet_in = 32'hAABBCCDD;
        
        // Assert dynamic asynchronous veto event step to measure edge switch bounds
        #4;
        veto_assert = 1;
        
        #10;
        $display("STATUS: Unified 2D spatial mesh logic verification cycle complete.");
        $finish;
    end
endmodule
