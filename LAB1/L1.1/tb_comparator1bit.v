
// tb_comparator1bit.v
`timescale 1ns/1ps
module tb_comparator1bit;
    reg A, B;
    wire o1, o2, o3;

    comparator1bit dut(.A(A), .B(B), .o1(o1), .o2(o2), .o3(o3));

    initial begin
        $dumpfile("comp1bit.vcd");
        $dumpvars(0, tb_comparator1bit);
        $display("A B | o1(A>B) o2(A==B) o3(A<B)");
        // Exhaustive test of 1-bit pairs
        A=0; B=0; #1; $display("%0d %0d |    %0d        %0d         %0d",A,B,o1,o2,o3);
        A=0; B=1; #1; $display("%0d %0d |    %0d        %0d         %0d",A,B,o1,o2,o3);
        A=1; B=0; #1; $display("%0d %0d |    %0d        %0d         %0d",A,B,o1,o2,o3);
        A=1; B=1; #1; $display("%0d %0d |    %0d        %0d         %0d",A,B,o1,o2,o3);
        #1 $finish;
    end
endmodule
