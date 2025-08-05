// Verilog module for a 1-bit comparator
module comparator_1bit (
              // Inputs
    input  A,
    input  B,

                // Outputs
    output o1, // A > B
    output o2, // A = B
    output o3  // A < B
);
    assign o1 = A & ~B;
    assign o2 = ~(A ^ B);
    assign o3 = ~A & B;

endmodule