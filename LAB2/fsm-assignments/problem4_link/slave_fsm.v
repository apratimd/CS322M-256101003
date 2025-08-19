// Slave: latch on req rising edge, assert ack for 2 cycles,
// then hold ack high until req goes low; expose last_byte for TB visibility.
module slave_fsm(
    input  wire       clk,
    input  wire       rst,       // synchronous active-high
    input  wire       req,       // from master
    input  wire [7:0] data_in,   // from master
    output reg        ack,       // to master
    output reg [7:0]  last_byte  // latched data (observable)
);
    reg req_d;           // for edge detection
    reg        ack_act;  // ack active flag
    reg [1:0]  hold;     // 2-cycle hold counter

    always @(posedge clk) begin
        if (rst) begin
            req_d     <= 1'b0;
            ack_act   <= 1'b0;
            hold      <= 2'd0;
            ack       <= 1'b0;
            last_byte <= 8'h00;
        end else begin
            req_d <= req;

            // On req rising edge, latch data and start 2-cycle ack hold
            if (req && !req_d) begin
                last_byte <= data_in;
                ack_act   <= 1'b1;
                hold      <= 2'd2;
            end

            // Decrement the 2-cycle hold while active
            if (ack_act && (hold != 2'd0)) begin
                hold <= hold - 2'd1;
            end

            // After hold is over, drop ack only after req is LOW
            if (ack_act && (hold == 2'd0) && !req) begin
                ack_act <= 1'b0;
            end

            ack <= ack_act;
        end
    end
endmodule
