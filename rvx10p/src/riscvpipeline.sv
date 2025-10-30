module riscvpipeline(
    input  logic        clk, reset,
    input  logic [31:0] instr,
    input  logic [31:0] readdata,
    output logic [31:0] pc,
    output logic        memwrite,
    output logic [31:0] aluout, 
    output logic [31:0] writedata
);

    // Internal control signals
    logic [1:0]  forwardA, forwardB;
    logic        stallF, stallD, flushD, flushE;
    logic        memtoregE, memtoregM, memtoregW;
    logic        alusrcE, regwriteE, regwriteM, regwriteW;
    logic [2:0]  alucontrolE;
    logic [4:0]  rs1E, rs2E, rdE, rdM, rdW;
    logic        branch_takenE;

    controller c(
        .clk(clk), .reset(reset),
        .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]),
        .memtoregE(memtoregE), .memtoregM(memtoregM), .memtoregW(memtoregW),
        .memwrite(memwrite), .alusrcE(alusrcE),
        .regwriteE(regwriteE), .regwriteM(regwriteM), .regwriteW(regwriteW),
        .alucontrolE(alucontrolE),
        .branch_takenE(branch_takenE)
    );

    datapath dp(
        .clk(clk), .reset(reset),
        .forwardA(forwardA), .forwardB(forwardB),
        .stallF(stallF), .stallD(stallD), .flushD(flushD), .flushE(flushE),
        .memtoregE(memtoregE), .memtoregM(memtoregM), .memtoregW(memtoregW),
        .alusrcE(alusrcE), .regwriteE(regwriteE), .regwriteM(regwriteM), .regwriteW(regwriteW),
        .alucontrolE(alucontrolE),
        .instr(instr), .readdata(readdata),
        .pc(pc), .aluout(aluout), .writedata(writedata),
        .rs1E(rs1E), .rs2E(rs2E), .rdE(rdE), .rdM(rdM), .rdW(rdW),
        .branch_takenE(branch_takenE)
    );

    hazard_unit hu(
        .rs1D(instr[19:15]), .rs2D(instr[24:20]),
        .rs1E(rs1E), .rs2E(rs2E),
        .rdE(rdE), .rdM(rdM), .rdW(rdW),
        .regwriteE(regwriteE), .regwriteM(regwriteM), .regwriteW(regwriteW),
        .memtoregE(memtoregE), .memtoregM(memtoregM),
        .branch_takenE(branch_takenE),
        .stallF(stallF), .stallD(stallD), .flushD(flushD), .flushE(flushE),
        .forwardA(forwardA), .forwardB(forwardB)
    );

endmodule