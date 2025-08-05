// Verilog module for a 4-bit equality comparator

module comparator_4bit_equality (
    // Inputs
    input  [3:0] A,
    input  [3:0] B,

    // Output
    output       EQ  // Outputs 1 if A == B
);
    assign EQ = (A == B);

endmodule