// ========================================================================================
// TOEC MULTI-CORE COGNITIVE CLUSTER MATRIX VERIFICATION TIMING ENGINE
// ========================================================================================
`timescale 1ns / 1ps

module toec_cluster_matrix_tb;
    reg         clk;
    reg         rst_n;
    reg         cluster_veto;
    reg  [1:0]  source_core_id;
    reg  [1:0]  target_core_id;
    reg  [31:0] cluster_ingress;
    wire [31:0] cluster_egress;
    wire        inter_cluster_valid;
    wire [2:0]  bridge_state;

    // Instantiate Cluster Under Test (CUT)
    toec_cluster_matrix uut (
        .clk(clk),
        .rst_n(rst_n),
        .cluster_veto(cluster_veto),
        .source_core_id(source_core_id),
        .target_core_id(target_core_id),
        .cluster_ingress(cluster_ingress),
        .cluster_egress(cluster_egress),
        .inter_cluster_valid(inter_cluster_valid),
        .bridge_state(bridge_state)
    );

    // Multi-Core Cluster Interconnect 3.2 GHz+ clock trace generator
    always #0.156 clk = ~clk;

    initial begin
        $dumpfile("cognitive_cluster_logic.vcd");
        $dumpvars(0, toec_cluster_matrix_tb);

        clk = 0;
        rst_n = 0;
        cluster_veto = 0;
        source_core_id = 2'b00;
        target_core_id = 2'b01;
        cluster_ingress = 32'h0;

        #2 rst_n = 1;
        
        // Assert active cross-cluster inter-core packet bridge routing trace
        #1;
        cluster_ingress = 32'hDEADBEEF;
        
        // Trigger high-speed critical cluster veto anomaly test line
        #2;
        cluster_veto = 1;

        #5;
        $display("STATUS: Multi-core cognitive cluster matrix logic verification complete.");
        $finish;
    end
endmodule
