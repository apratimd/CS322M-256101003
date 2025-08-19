
// tb_eq4.v
`timescale 1ns/1ps
module tb_eq4;
    reg  [3:0] A, B;
    wire       eq;

    eq4 dut(.A(A), .B(B), .eq(eq));

    integer i;

    initial begin
        $dumpfile("eq4.vcd");
        $dumpvars(0, tb_eq4);
        $display("    A     B   | eq (A==B)");
        // Sweep a few representative pairs, including all-equal cases
        for (i = 0; i < 16; i = i + 1) begin
            A = i[3:0]; B = i[3:0]; #1;
            $display("%2h (=%0d) %2h (=%0d) |   %0d", A, A, B, B, eq);
        end

        // Some non-equal spot checks
        A = 4'h0; B = 4'hF; #1; $display("%2h       %2h     |   %0d", A, B, eq);
        A = 4'hA; B = 4'h5; #1; $display("%2h       %2h     |   %0d", A, B, eq);
        A = 4'h7; B = 4'h8; #1; $display("%2h       %2h     |   %0d", A, B, eq);

        #1 $finish;
    end
endmodule
