
module seq_detect_mealy (
    input  wire clk,
    input  wire rst, 
    input  wire din, 
    output wire y    
);

    // Define states using local parameters for better readability
    localparam S_IDLE = 2'b00; // No bits matched
    localparam S_1    = 2'b01; // "1" matched
    localparam S_11   = 2'b10; // "11" matched
    localparam S_110  = 2'b11; // "110" matched

    // State registers
    reg [1:0] state_reg, state_next;

    // 1. Sequential Block: State Register Update
    // Handles state transitions on the clock edge and synchronous reset.
    always @(posedge clk) begin
        if (rst) begin
            state_reg <= S_IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    // 2. Combinational Block: Next State Logic
    // Determines the next state based on the current state and input.
    always @(*) begin
        case (state_reg)
            S_IDLE: begin
                if (din)
                    state_next = S_1;
                else
                    state_next = S_IDLE;
            end
            S_1: begin
                if (din)
                    state_next = S_11;
                else
                    state_next = S_IDLE;
            end
            S_11: begin
                if (din)
                    state_next = S_11; // Overlap: ...11 + 1 -> ...11
                else
                    state_next = S_110;
            end
            S_110: begin
                if (din)
                    state_next = S_1; // Detected: last '1' is the start of a new sequence
                else
                    state_next = S_IDLE;
            end
            default: begin
                state_next = S_IDLE;
            end
        endcase
    end

    // 3. Combinational Block: Output Logic (Mealy)
    // Output depends on the current state AND the current input.
    // y is '1' only when in state S_110 and input din is '1'.
    assign y = (state_reg == S_110) && (din == 1'b1);

endmodule