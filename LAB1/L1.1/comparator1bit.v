
// comparator1bit.v
// 1-bit comparator: o1=1 if A>B, o2=1 if A==B, o3=1 if A<B
module comparator1bit(
    input  wire A,
    input  wire B,
    output wire o1, // A > B
    output wire o2, // A == B
    output wire o3  // A < B
);
    assign o1 =  A & ~B;
    assign o2 = ~(A ^  B); // XNOR
    assign o3 = ~A &  B;
endmodule
