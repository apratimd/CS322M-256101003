`timescale 1ns/1ps
module tb_vending_mealy;
    reg        clk = 1'b0;
    reg        rst = 1'b1;
    reg  [1:0] coin = 2'b00;   // 01->5, 10->10
    wire       dispense, chg5;

    // DUT
    vending_mealy dut(
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Drive exactly one coin for one cycle, then one idle cycle
    task put_coin(input [1:0] c);
        begin
            @(negedge clk); coin = c;
            @(negedge clk); coin = 2'b00; // idle between coins
        end
    endtask

    initial begin
        $dumpfile("vending_mealy.vcd");
        $dumpvars(0, tb_vending_mealy);

        // release reset
        repeat (2) @(negedge clk);
        rst = 1'b0;

        // Scenario 1: 10 + 10 => vend (no change)
        put_coin(2'b10);
        put_coin(2'b10);
        repeat (2) @(negedge clk);

        // Scenario 2: 5 + 5 + 5 + 5 => vend (no change)
        put_coin(2'b01);
        put_coin(2'b01);
        put_coin(2'b01);
        put_coin(2'b01);
        repeat (2) @(negedge clk);

        // Scenario 3: 5 + 10 + 10 => total 25 => vend + chg5
        put_coin(2'b01);
        put_coin(2'b10);
        put_coin(2'b10);
        repeat (3) @(negedge clk);

        // Ignore invalid/idle
        @(negedge clk); coin = 2'b11; // ignored
        @(negedge clk); coin = 2'b00;

        repeat (4) @(negedge clk);
        $finish;
    end
endmodule
