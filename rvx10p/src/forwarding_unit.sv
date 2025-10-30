module forwarding_unit(
    input  logic [4:0]  rs1E, rs2E,
    input  logic [4:0]  rdM, rdW,
    input  logic        regwriteM, regwriteW,
    output logic [1:0]  forwardA, forwardB
);

    always_comb begin
        // ForwardA (EX stage rs1)
        if ((rs1E != 0) & (rs1E == rdM) & regwriteM)
            forwardA = 2'b10; // Forward from MEM
        else if ((rs1E != 0) & (rs1E == rdW) & regwriteW)
            forwardA = 2'b01; // Forward from WB
        else
            forwardA = 2'b00; // No forwarding
            
        // ForwardB (EX stage rs2)  
        if ((rs2E != 0) & (rs2E == rdM) & regwriteM)
            forwardB = 2'b10; // Forward from MEM
        else if ((rs2E != 0) & (rs2E == rdW) & regwriteW)
            forwardB = 2'b01; // Forward from WB
        else
            forwardB = 2'b00; // No forwarding
    end

endmodule