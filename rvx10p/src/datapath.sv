module datapath(
    input  logic        clk, reset,
    input  logic [1:0]  forwardA, forwardB,
    input  logic        stallF, stallD, flushD, flushE,
    input  logic        memtoregE, memtoregM, memtoregW,
    input  logic        alusrcE, regwriteE, regwriteM, regwriteW,
    input  logic [2:0]  alucontrolE,
    input  logic [31:0] instr,
    input  logic [31:0] readdata,
    output logic [31:0] pc,
    output logic [31:0] aluout,
    output logic [31:0] writedata,
    output logic [4:0]  rs1E, rs2E, rdE, rdM, rdW,
    output logic        branch_takenE
);

    // Pipeline registers
    logic [31:0] pcF, pcPlus4F, pcD, pcPlus4D;
    logic [31:0] instrD;
    logic [31:0] rd1D, rd2D, rd1E, rd2E;
    logic [31:0] immExtD, immExtE;
    logic [31:0] aluoutM, aluoutW;
    logic [31:0] readdataW;
    logic [31:0] resultW;

    // Internal signals
    logic [31:0] pcNext, pcBranch;
    logic [31:0] srcAE, srcBE;
    logic [31:0] forwardAE, forwardBE;

    // IF Stage
    assign pcNext = branch_takenE ? pcBranch : pcPlus4F;
    
    always_ff @(posedge clk) begin
        if (reset) pcF <= 0;
        else if (~stallF) pcF <= pcNext;
    end
    
    assign pcPlus4F = pcF + 4;
    assign pc = pcF;

    // IF/ID Pipeline Register
    always_ff @(posedge clk) begin
        if (reset | flushD) begin
            instrD <= 0;
            pcD <= 0;
            pcPlus4D <= 0;
        end else if (~stallD) begin
            instrD <= instr;
            pcD <= pcF;
            pcPlus4D <= pcPlus4F;
        end
    end

    // ID Stage
    regfile rf(.clk(clk), .we3(regwriteW), .ra1(instrD[19:15]), 
               .ra2(instrD[24:20]), .wa3(rdW), .wd3(resultW), 
               .rd1(rd1D), .rd2(rd2D));
    
    immgen ig(.instr(instrD), .imm(immExtD));
    
    assign rs1E = instrD[19:15];
    assign rs2E = instrD[24:20];
    assign rdE = instrD[11:7];

    // ID/EX Pipeline Register
    always_ff @(posedge clk) begin
        if (reset | flushE) begin
            rd1E <= 0; rd2E <= 0; immExtE <= 0;
        end else begin
            rd1E <= rd1D; rd2E <= rd2D; immExtE <= immExtD;
        end
    end

    // EX Stage
    // Forwarding muxes
    always_comb begin
        case(forwardA)
            2'b00: forwardAE = rd1E;
            2'b01: forwardAE = resultW;
            2'b10: forwardAE = aluoutM;
            default: forwardAE = rd1E;
        endcase
        
        case(forwardB)
            2'b00: forwardBE = rd2E;
            2'b01: forwardBE = resultW;
            2'b10: forwardBE = aluoutM;
            default: forwardBE = rd2E;
        endcase
    end

    assign srcAE = forwardAE;
    assign srcBE = alusrcE ? immExtE : forwardBE;
    assign writedata = forwardBE;

    alu alu_unit(.a(srcAE), .b(srcBE), .alucontrol(alucontrolE), 
                 .result(aluout), .zero(branch_takenE));

    assign pcBranch = pcD + immExtD;

    // EX/MEM Pipeline Register
    always_ff @(posedge clk) begin
        if (reset) begin
            aluoutM <= 0;
            rdM <= 0;
        end else begin
            aluoutM <= aluout;
            rdM <= rdE;
        end
    end

    // MEM Stage - Memory access handled externally

    // MEM/WB Pipeline Register
    always_ff @(posedge clk) begin
        if (reset) begin
            aluoutW <= 0;
            readdataW <= 0;
            rdW <= 0;
        end else begin
            aluoutW <= aluoutM;
            readdataW <= readdata;
            rdW <= rdM;
        end
    end

    // WB Stage
    assign resultW = memtoregW ? readdataW : aluoutW;

endmodule

// Supporting modules
module regfile(
    input  logic        clk, we3,
    input  logic [4:0]  ra1, ra2, wa3,
    input  logic [31:0] wd3,
    output logic [31:0] rd1, rd2
);
    logic [31:0] rf[31:0];
    
    always_ff @(posedge clk) begin
        if (we3 && wa3 != 0) rf[wa3] <= wd3;
    end
    
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module immgen(
    input  logic [31:0] instr,
    output logic [31:0] imm
);
    always_comb begin
        case(instr[6:0])
            7'b0010011: imm = {{21{instr[31]}}, instr[30:20]}; // I-type
            7'b0100011: imm = {{21{instr[31]}}, instr[30:25], instr[11:7]}; // S-type
            7'b1100011: imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
            default:     imm = 32'b0;
        endcase
    end
endmodule

module alu(
    input  logic [31:0] a, b,
    input  logic [2:0]  alucontrol,
    output logic [31:0] result,
    output logic        zero
);
    always_comb begin
        case(alucontrol)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            default: result = a + b;
        endcase
        zero = (result == 0);
    end
endmodule