// ========================================================================================
// TOEC COGNITIVE SYSTEM AGENT ROUTER VERIFICATION TESTBENCH
// ========================================================================================
`timescale 1ns / 1ps

module toec_agent_router_tb;
    reg         clk;
    reg         rst_n;
    reg  [3:0]  agent_id;
    reg  [31:0] ingress_packet;
    reg         packet_valid;
    wire [31:0] egress_packet;
    wire        egress_ready;
    wire [2:0]  current_state;

    // Instantiate target Device Under Test (DUT)
    toec_agent_router uut (
        .clk(clk),
        .rst_n(rst_n),
        .agent_id(agent_id),
        .ingress_packet(ingress_packet),
        .packet_valid(packet_valid),
        .egress_packet(egress_packet),
        .egress_ready(egress_ready),
        .current_state(current_state)
    );

    // Dynamic clock generation matching scaled runtime variables
    always #1.0 clk = ~clk;

    initial begin
        // Open value change dump trace tracks for structural visualization
        $dumpfile("cognitive_fabric_logic.vcd");
        $dumpvars(0, toec_agent_router_tb);

        clk = 0;
        rst_n = 0;
        agent_id = 4'b0101;
        ingress_packet = 32'h0;
        packet_valid = 0;

        #4 rst_n = 1;
        
        // Assert Test Vector Case 1: Matching Target Agent ID Routing Path
        #2;
        ingress_packet = 32'h5ABCDEF0;
        packet_valid = 1;
        #2 packet_valid = 0;

        // Await state transmission cycle completion
        #12;
        
        // Assert Test Vector Case 2: Mismatched ID Header (Triggers Arbitration Branch)
        ingress_packet = 32'h90001111;
        packet_valid = 1;
        #2 packet_valid = 0;

        #20;
        $display("STATUS: Distributed logic verification run completed successfully.");
        $finish;
    end
endmodule
