
// eq4.v
// 4-bit equality comparator: eq=1 if A == B
module eq4(
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire       eq
);
    // Bitwise XNOR then reduce AND, or simply (A==B)
    assign eq = &(A ~^ B);
endmodule
