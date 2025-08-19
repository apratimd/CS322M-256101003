// tb_traffic_light.v (fixed: no zero-arg function)
`timescale 1ns/1ps

module tb_traffic_light;
    // Clock: 100 MHz
    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst;

    // Fast simulation tick: 1 pulse every TICK_CYC clocks
    localparam integer TICK_CYC = 20;
    reg tick;
    integer cyc;

    // DUT outputs
    wire ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;

    // DUT
    traffic_light #(
        .NS_G_TICKS(5), .NS_Y_TICKS(2),
        .EW_G_TICKS(5), .EW_Y_TICKS(2)
    ) dut (
        .clk (clk),
        .rst (rst),
        .tick(tick),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    // Generate a 1-cycle 'tick' every TICK_CYC clocks
    always @(posedge clk) begin
        if (rst) begin
            cyc  <= 0;
            tick <= 1'b0;
        end else begin
            if (cyc == TICK_CYC-1) begin
                cyc  <= 0;
                tick <= 1'b1;
            end else begin
                cyc  <= cyc + 1;
                tick <= 1'b0;
            end
        end
    end

    // One-hot and safety checks
    always @(posedge clk) if (!rst) begin
        if ((ns_g + ns_y + ns_r) != 1) begin
            $error("NS lights not one-hot!"); $stop;
        end
        if ((ew_g + ew_y + ew_r) != 1) begin
            $error("EW lights not one-hot!"); $stop;
        end
        if (ns_g && ew_g) begin
            $error("Both NS and EW green!"); $stop;
        end
    end

    // Log phase on every tick (simple if/else, no function)
    always @(posedge clk) if (tick) begin
        if (ns_g)
            $display("[%0t ns] TICK -> NS_G  (NS: G=%0b Y=%0b R=%0b | EW: G=%0b Y=%0b R=%0b)",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
        else if (ns_y)
            $display("[%0t ns] TICK -> NS_Y  (NS: G=%0b Y=%0b R=%0b | EW: G=%0b Y=%0b R=%0b)",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
        else if (ew_g)
            $display("[%0t ns] TICK -> EW_G  (NS: G=%0b Y=%0b R=%0b | EW: G=%0b Y=%0b R=%0b)",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
        else
            $display("[%0t ns] TICK -> EW_Y  (NS: G=%0b Y=%0b R=%0b | EW: G=%0b Y=%0b R=%0b)",
                     $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
    end

    initial begin
        $dumpfile("traffic_light_tb.vcd");
        $dumpvars(0, tb_traffic_light);

        rst = 1'b1; repeat (3) @(posedge clk); rst = 1'b0;

        // Run for ~40 ticks
        repeat (40*TICK_CYC + 10) @(posedge clk);

        $display("Simulation done.");
        $finish;
    end
endmodule
