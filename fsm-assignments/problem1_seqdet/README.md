# Problem 1: Overlapping Mealy Sequence Detector for "1101"

This project contains the Verilog RTL and testbench for a Mealy Finite State Machine (FSM) that detects the sequence `1101` in a serial bitstream. The detector correctly handles overlapping sequences.

## File Structure

```
problem1_seqdet/
├── seq_detect_mealy.v      # Synthesizable RTL module
├── tb_seq_detect_mealy.v   # Testbench for the module
├── README.md               # This file
└── waves/                    # Directory for VCD/PNG output
    └── dump.vcd            # Generated waveform file
```

## How to Compile and Run

This project can be simulated using open-source tools like Icarus Verilog and GTKWave.

1.  **Compile the Verilog files:**
    Open your terminal in the `problem1_seqdet/` directory and run the following command to compile the source files into a `vvp` executable.

    ```bash
    iverilog -o tb_seq_detect_mealy.vvp seq_detect_mealy.v tb_seq_detect_mealy.v
    ```

2.  **Run the simulation:**
    Execute the compiled file. This will run the testbench and generate a `dump.vcd` waveform file.

    ```bash
    vvp tb_seq_detect_mealy.vvp
    ```

## How to Visualize Waveforms

1.  **Open GTKWave:**
    Use GTKWave (or another waveform viewer like ModelSim/QuestaSim) to open the generated VCD file.

    ```bash
    gtkwave dump.vcd
    ```

2.  **View Signals:**
    In the GTKWave interface, select the signals `clk`, `rst`, `din`, `y`, and `dut.state_reg` to add them to the waves panel for analysis.

## Expected Behavior

The testbench drives the input stream `1101101101` into the `din` port after an initial reset. The clock period is 10ns.

The output `y` is expected to pulse high for one full clock cycle upon detection of the final '1' in the `1101` sequence.

-   **First Detection:** at **t = 60 ns**
-   **Second Detection:** at **t = 90 ns**
-   **Third Detection:** at **t = 120 ns**

The state register `dut.state_reg` can also be observed to trace the FSM's transitions as described in the state diagram.