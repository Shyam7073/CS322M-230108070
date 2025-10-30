module controller(
    input  logic        clk, reset,
    input  logic [6:0]  opcode,
    input  logic [2:0]  funct3,
    input  logic [6:0]  funct7,
    output logic        memtoregE, memtoregM, memtoregW,
    output logic        memwrite,
    output logic        alusrcE,
    output logic        regwriteE, regwriteM, regwriteW,
    output logic [2:0]  alucontrolE,
    output logic        branch_takenE
);

    // Main decoder signals
    logic [1:0] aluop;
    logic       branch, jump;
    
    // Control signal pipeline registers
    always_ff @(posedge clk) begin
        if (reset) begin
            {memtoregE, memtoregM, memtoregW} <= '0;
            {regwriteE, regwriteM, regwriteW} <= '0;
            alusrcE <= '0;
        end else begin
            // Pipeline control signals
            memtoregM <= memtoregE;
            memtoregW <= memtoregM;
            regwriteM <= regwriteE;
            regwriteW <= regwriteM;
        end
    end

    // Main decoder
    always_comb begin
        case(opcode)
            // RV32I instructions
            7'b0110011: begin alusrcE = 0; memtoregE = 0; regwriteE = 1; memwrite = 0; branch = 0; aluop = 2'b10; end // R-type
            7'b0010011: begin alusrcE = 1; memtoregE = 0; regwriteE = 1; memwrite = 0; branch = 0; aluop = 2'b10; end // I-type
            7'b0000011: begin alusrcE = 1; memtoregE = 1; regwriteE = 1; memwrite = 0; branch = 0; aluop = 2'b00; end // Load
            7'b0100011: begin alusrcE = 1; memtoregE = 0; regwriteE = 0; memwrite = 1; branch = 0; aluop = 2'b00; end // Store
            7'b1100011: begin alusrcE = 0; memtoregE = 0; regwriteE = 0; memwrite = 0; branch = 1; aluop = 2'b01; end // Branch
            default:    begin alusrcE = 0; memtoregE = 0; regwriteE = 0; memwrite = 0; branch = 0; aluop = 2'b00; end
        endcase
    end

    // ALU decoder for RV32I + RVX10
    always_comb begin
        case(aluop)
            2'b00: alucontrolE = 3'b000; // Add
            2'b01: alucontrolE = 3'b001; // Subtract
            2'b10: begin
                case(funct3)
                    3'b000: alucontrolE = (funct7[5] & opcode[5]) ? 3'b001 : 3'b000; // ADD/SUB
                    3'b111: alucontrolE = 3'b010; // AND
                    3'b110: alucontrolE = 3'b011; // OR
                    3'b100: alucontrolE = 3'b100; // XOR
                    // RVX10 custom instructions would be decoded here
                    default: alucontrolE = 3'b000;
                endcase
            end
            default: alucontrolE = 3'b000;
        endcase
    end

    // Branch logic (simplified)
    assign branch_takenE = branch; // Actual branch condition would be computed in datapath

endmodule