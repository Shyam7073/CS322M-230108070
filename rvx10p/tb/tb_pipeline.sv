module tb_pipeline;
    logic        clk, reset;
    logic [31:0] instr;
    logic [31:0] readdata;
    logic [31:0] pc;
    logic        memwrite;
    logic [31:0] aluout;
    logic [31:0] writedata;
    
    // Instantiate pipeline
    riscvpipeline dut(
        .clk(clk), .reset(reset),
        .instr(instr), .readdata(readdata),
        .pc(pc), .memwrite(memwrite),
        .aluout(aluout), .writedata(writedata)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test memory (simplified)
    logic [31:0] memory [0:255];
    
    initial begin
        // Initialize memory with test program
        memory[0] = 32'h00000000; // nop
        memory[1] = 32'h00000000; // nop
        // Add your test instructions here
        
        readdata = 0;
    end
    
    // Provide instructions
    always_ff @(posedge clk) begin
        instr <= memory[pc[31:2]];
    end
    
    // Memory write monitoring
    always_ff @(posedge clk) begin
        if (memwrite) begin
            memory[aluout[31:2]] <= writedata;
            // Check for success condition (store 25 to address 100)
            if (aluout == 100 && writedata == 25) begin
                $display("SUCCESS: Store 25 to address 100 detected");
                $finish;
            end
        end
    end
    
    // Test sequence
    initial begin
        reset = 1;
        #10 reset = 0;
        
        // Run for some cycles
        #1000;
        $display("FAIL: Test timeout");
        $finish;
    end

endmodule