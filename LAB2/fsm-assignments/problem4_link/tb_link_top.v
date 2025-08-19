`timescale 1ns/1ps
module tb_link_top;
    // clock & reset
    reg clk = 1'b0;
    reg rst = 1'b1;
    wire done;

    // DUT
    link_top dut(.clk(clk), .rst(rst), .done(done));

    // 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD
        $dumpfile("link.vcd");
        $dumpvars(0, tb_link_top);

        // Reset for a few cycles
        repeat (4) @(posedge clk);
        rst <= 1'b0;

        // Run until done is seen, then a few extra cycles
        wait (done === 1'b1);
        @(posedge clk);
        @(posedge clk);
        $finish;
    end
endmodule
