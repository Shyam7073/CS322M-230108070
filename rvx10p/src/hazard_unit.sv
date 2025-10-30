module hazard_unit(
    input  logic [4:0]  rs1D, rs2D,
    input  logic [4:0]  rs1E, rs2E,
    input  logic [4:0]  rdE, rdM, rdW,
    input  logic        regwriteE, regwriteM, regwriteW,
    input  logic        memtoregE, memtoregM,
    input  logic        branch_takenE,
    output logic        stallF, stallD, flushD, flushE,
    output logic [1:0]  forwardA, forwardB
);

    // Load-use hazard detection
    logic lwstall;
    
    assign lwstall = memtoregE & ((rs1D == rdE) | (rs2D == rdE));
    
    assign stallF = lwstall;
    assign stallD = lwstall;
    assign flushE = lwstall;
    
    // Branch hazard
    assign flushD = branch_takenE;

    // Forwarding logic
    always_comb begin
        // ForwardA
        if ((rs1E != 0) & (rs1E == rdM) & regwriteM)
            forwardA = 2'b10;
        else if ((rs1E != 0) & (rs1E == rdW) & regwriteW)
            forwardA = 2'b01;
        else
            forwardA = 2'b00;
            
        // ForwardB  
        if ((rs2E != 0) & (rs2E == rdM) & regwriteM)
            forwardB = 2'b10;
        else if ((rs2E != 0) & (rs2E == rdW) & regwriteW)
            forwardB = 2'b01;
        else
            forwardB = 2'b00;
    end

endmodule