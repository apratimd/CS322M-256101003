`timescale 1ns/1ps

module tb_seq_detect_mealy;
    // DUT I/O
    reg  clk = 1'b0;
    reg  rst = 1'b1;    // start in reset
    reg  din = 1'b0;
    wire y;

    // Instantiate DUT
    seq_detect_mealy dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .y  (y)
    );

    // 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    // Bitstream to drive (MSB first).
    // This stream contains multiple overlapping "1101" occurrences.
    // For reference: "11011011101" → y should pulse when indices (0-based) end at 3, 6, 10.
    localparam integer N = 11;
    reg [N-1:0] stream = 11'b11011011101;

    integer i;

    initial begin
        // VCD
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_seq_detect_mealy);

        // Hold reset for a couple of cycles
        repeat (2) @(posedge clk);
        rst <= 1'b0;
        @(posedge clk); // settle

        $display("Time   idx  din  y   (y pulses on the cycle the last '1' of 1101 arrives)");
        // Drive MSB->LSB, one bit per rising edge
        for (i = N-1; i >= 0; i = i - 1) begin
            din <= stream[i];
            @(posedge clk);
            $display("%0t  %2d    %0d    %0d", $time, (N-1 - i), stream[i], y);
        end

        // a few idle clocks
        din <= 1'b0;
        repeat (3) @(posedge clk);

        $finish;
    end
endmodule
