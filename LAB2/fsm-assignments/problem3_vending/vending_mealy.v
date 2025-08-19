`timescale 1ns/1ps
// Mealy vending machine: price = 20
// coin[1:0]: 01 -> 5, 10 -> 10, 00/11 -> idle/ignore
// dispense: 1-cycle pulse when total >= 20
// chg5:     1-cycle pulse when total == 25
module vending_mealy(
    input  wire       clk,
    input  wire       rst,        // synchronous, active-high
    input  wire [1:0] coin,       // 01=5, 10=10, 00/11=idle/ignore
    output reg        dispense,   // 1-cycle pulse
    output reg        chg5        // 1-cycle pulse with dispense on 25
);
    // State encodes running total: 0, 5, 10, 15
    localparam S0  = 2'd0;
    localparam S5  = 2'd1;
    localparam S10 = 2'd2;
    localparam S15 = 2'd3;

    reg [1:0] state, next;

    // Next-state + Mealy outputs
    always @* begin
        // defaults
        next     = state;
        dispense = 1'b0;
        chg5     = 1'b0;

        case (state)
            S0: begin
                case (coin)
                    2'b01: next = S5;    // +5
                    2'b10: next = S10;   // +10
                    default: next = S0;  // idle/ignore
                endcase
            end

            S5: begin
                case (coin)
                    2'b01: next = S10;   // 5+5
                    2'b10: next = S15;   // 5+10
                    default: next = S5;
                endcase
            end

            S10: begin
                case (coin)
                    2'b01: next = S15;   // 10+5
                    2'b10: begin         // 10+10 = 20 -> vend
                        dispense = 1'b1;
                        next     = S0;    // reset after vend
                    end
                    default: next = S10;
                endcase
            end

            S15: begin
                case (coin)
                    2'b01: begin         // 15+5 = 20 -> vend
                        dispense = 1'b1;
                        next     = S0;
                    end
                    2'b10: begin         // 15+10 = 25 -> vend + change
                        dispense = 1'b1;
                        chg5     = 1'b1;
                        next     = S0;
                    end
                    default: next = S15;
                endcase
            end
        endcase
    end

    // State register (sync, active-high reset)
    always @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next;
    end
endmodule
