`timescale 1ns / 1ps

module tb_seq_detect_mealy;

    // Testbench signals
    reg clk;
    reg rst;
    reg din;
    wire y;

    // Instantiate the DUT (Device Under Test)
    seq_detect_mealy dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .y(y)
    );

    // 1. Clock Generation (100 MHz)
    localparam CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // 2. Test Sequence
    initial begin
        // Setup waveform dumping
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_seq_detect_mealy);

        // Initialize and apply synchronous reset
        rst = 1'b1;
        din = 1'b0;
        @(posedge clk);
        @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        // Drive the bitstream with overlaps: 1101101101
        // Drive input on the negedge to avoid setup/hold issues
        drive_bit(1'b1); // t=30ns, seq: 1
        drive_bit(1'b1); // t=40ns, seq: 11
        drive_bit(1'b0); // t=50ns, seq: 110
        drive_bit(1'b1); // t=60ns, seq: 1101 -> DETECT!
        drive_bit(1'b1); // t=70ns, seq: 11 (from 11011)
        drive_bit(1'b0); // t=80ns, seq: 110
        drive_bit(1'b1); // t=90ns, seq: 1101 -> DETECT!
        drive_bit(1'b1); // t=100ns, seq: 11 (from 11011)
        drive_bit(1'b0); // t=110ns, seq: 110
        drive_bit(1'b1); // t=120ns, seq: 1101 -> DETECT!
        drive_bit(1'b0); // t=130ns

        #20;
        $finish;
    end

    // Task to drive one bit per clock cycle
    task drive_bit (input bit_val);
        @(negedge clk);
        din = bit_val;
    endtask

endmodule