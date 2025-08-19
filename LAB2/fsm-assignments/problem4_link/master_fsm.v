// Master: drives 4 bytes with 4‑phase handshake
module master_fsm(
    input  wire       clk,
    input  wire       rst,   // synchronous active-high
    input  wire       ack,   // from slave
    output reg        req,   // to slave
    output reg [7:0]  data,  // to slave
    output reg        done   // 1-cycle pulse after 4 bytes
);

    // simple 4‑entry ROM (A0..A3) for the burst payload
    reg [7:0] rom [0:3];
    initial begin
        rom[0] = 8'hA0;
        rom[1] = 8'hA1;
        rom[2] = 8'hA2;
        rom[3] = 8'hA3;
    end

    localparam S_IDLE        = 3'd0,
               S_DRIVE       = 3'd1,
               S_WAIT_ACK_HI = 3'd2,
               S_DROP_REQ    = 3'd3,
               S_WAIT_ACK_LO = 3'd4,
               S_NEXT_BYTE   = 3'd5,
               S_DONE        = 3'd6;

    reg [2:0] state;
    reg [1:0] idx;  // 0..3

    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            idx   <= 2'd0;
            req   <= 1'b0;
            data  <= 8'h00;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;  // default

            case (state)
                S_IDLE: begin
                    idx  <= 2'd0;
                    data <= rom[0];
                    req  <= 1'b0;
                    state <= S_DRIVE;
                end

                // Drive current byte and raise req
                S_DRIVE: begin
                    data <= rom[idx];
                    req  <= 1'b1;
                    state <= S_WAIT_ACK_HI;
                end

                // Wait for slave to assert ack
                S_WAIT_ACK_HI: begin
                    if (ack) state <= S_DROP_REQ;
                end

                // Drop req once ack is seen
                S_DROP_REQ: begin
                    req   <= 1'b0;
                    state <= S_WAIT_ACK_LO;
                end

                // Wait for slave to drop ack
                S_WAIT_ACK_LO: begin
                    if (!ack) begin
                        if (idx == 2'd3) state <= S_DONE;
                        else             state <= S_NEXT_BYTE;
                    end
                end

                // Advance to next byte
                S_NEXT_BYTE: begin
                    idx  <= idx + 2'd1;
                    data <= rom[idx + 2'd1];
                    state <= S_DRIVE;
                end

                // Pulse done for one cycle
                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
