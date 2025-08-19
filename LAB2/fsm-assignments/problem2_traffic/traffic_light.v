// traffic_light.v
// Moore two-road traffic light controlled by a slow 1-cycle 'tick' pulse.
// Synchronous, active-high reset. Exactly one of {g,y,r} is high per road.

module traffic_light #(
    // Phase durations in ticks
    parameter integer NS_G_TICKS = 5,
    parameter integer NS_Y_TICKS = 2,
    parameter integer EW_G_TICKS = 5,
    parameter integer EW_Y_TICKS = 2
)(
    input  wire clk,   // fast system clock
    input  wire rst,   // synchronous, active-high
    input  wire tick,  // 1-cycle pulse; phase counter advances only when tick=1

    output reg  ns_g,  // North-South green
    output reg  ns_y,  // North-South yellow
    output reg  ns_r,  // North-South red
    output reg  ew_g,  // East-West green
    output reg  ew_y,  // East-West yellow
    output reg  ew_r   // East-West red
);

    // States (Moore)
    localparam [1:0] S_NS_G = 2'd0,
                     S_NS_Y = 2'd1,
                     S_EW_G = 2'd2,
                     S_EW_Y = 2'd3;

    reg  [1:0] state, next_state;
    reg  [7:0] phase_cnt;  // wide enough for worst-case tick count

    // Duration for current state
    reg [7:0] current_len;
    always @* begin
        case (state)
            S_NS_G: current_len = NS_G_TICKS[7:0];
            S_NS_Y: current_len = NS_Y_TICKS[7:0];
            S_EW_G: current_len = EW_G_TICKS[7:0];
            default: current_len = EW_Y_TICKS[7:0]; // S_EW_Y
        endcase
    end

    // Next-state logic (advance only on the last tick of the phase)
    always @* begin
        next_state = state;
        if (tick && (phase_cnt == current_len - 1)) begin
            case (state)
                S_NS_G: next_state = S_NS_Y;
                S_NS_Y: next_state = S_EW_G;
                S_EW_G: next_state = S_EW_Y;
                S_EW_Y: next_state = S_NS_G;
            endcase
        end
    end

    // State and phase counter registers
    always @(posedge clk) begin
        if (rst) begin
            state     <= S_NS_G;
            phase_cnt <= 8'd0;
        end else begin
            state <= next_state;

            // Counter bumps only on tick; clears at phase rollover or state change
            if (tick) begin
                if (phase_cnt == current_len - 1)
                    phase_cnt <= 8'd0;
                else
                    phase_cnt <= phase_cnt + 1'b1;
            end
        end
    end

    // Moore outputs by state
    always @* begin
        // Defaults: all red
        ns_g = 1'b0; ns_y = 1'b0; ns_r = 1'b1;
        ew_g = 1'b0; ew_y = 1'b0; ew_r = 1'b1;

        case (state)
            S_NS_G: begin ns_g = 1'b1; ns_r = 1'b0; ew_r = 1'b1; end
            S_NS_Y: begin ns_y = 1'b1; ns_r = 1'b0; ew_r = 1'b1; end
            S_EW_G: begin ew_g = 1'b1; ew_r = 1'b0; ns_r = 1'b1; end
            S_EW_Y: begin ew_y = 1'b1; ew_r = 1'b0; ns_r = 1'b1; end
        endcase
    end
endmodule
