// Problem 1: Mealy overlapping sequence detector for pattern 1101
// Synchronous, active-high reset. y pulses one cycle when '1101' completed.

module seq_detect_mealy(
    input  wire clk,
    input  wire rst,   // synchronous, active-high
    input  wire din,   // serial input bit per clock
    output reg  y      // 1-cycle pulse when pattern ...1101 seen
);
    // State encoding:
    // S0: no prefix
    // S1: seen '1'
    // S2: seen '11'
    // S3: seen '110'
    localparam S0 = 2'd0,
               S1 = 2'd1,
               S2 = 2'd2,
               S3 = 2'd3;

    reg [1:0] state, next_state;

    // Next-state and Mealy output logic
    always @* begin
        next_state = state;
        y          = 1'b0;  // default

        case (state)
            S0: begin
                // expecting first '1'
                next_state = din ? S1 : S0;
            end

            S1: begin
                // we have '1', want another '1'
                next_state = din ? S2 : S0;
            end

            S2: begin
                // we have '11', want a '0' to go to S3; '1' keeps us in S2 (overlap)
                next_state = din ? S2 : S3;
            end

            S3: begin
                // we have '110', want a '1' to complete '1101'
                if (din) begin
                    y          = 1'b1; // pulse now (Mealy) with last bit
                    next_state = S1;    // overlap: last '1' can start a new match
                end else begin
                    next_state = S0;
                end
            end

            default: begin
                next_state = S0;
            end
        endcase
    end

    // State register with synchronous, active-high reset
    always @(posedge clk) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end
endmodule
