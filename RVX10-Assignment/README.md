# RVX10 Instruction Set Extension

## Project Overview
This project implements 10 new single-cycle instructions (RVX10) for the RV32I RISC-V core using the custom opcode space (0x0B). The implementation maintains full compatibility with the base RV32I ISA.

## New Instructions
1. **ANDN** - AND NOT: `rd = rs1 & ~rs2`
2. **ORN** - OR NOT: `rd = rs1 | ~rs2`  
3. **XNOR** - Exclusive NOR: `rd = ~(rs1 ^ rs2)`
4. **MIN** - Signed Minimum: `rd = (signed(rs1) < signed(rs2)) ? rs1 : rs2`
5. **MAX** - Signed Maximum: `rd = (signed(rs1) > signed(rs2)) ? rs1 : rs2`
6. **MINU** - Unsigned Minimum: `rd = (rs1 < rs2) ? rs1 : rs2`
7. **MAXU** - Unsigned Maximum: `rd = (rs1 > rs2) ? rs1 : rs2`
8. **ROL** - Rotate Left: `rd = (rs1 << shamt) | (rs1 >> (32-shamt))`
9. **ROR** - Rotate Right: `rd = (rs1 >> shamt) | (rs1 << (32-shamt))`
10. **ABS** - Absolute Value: `rd = (signed(rs1) >= 0) ? rs1 : -rs1`

## Files Structure
project/
├── src/
│ └── riscvsingle.sv # Main processor with RVX10 implementation
├── docs/
│ ├── ENCODINGS.md # Instruction encoding documentation
│ └── TESTPLAN.md # Test plan and expected results
├── tests/
│ └── rvx10.hex # Test program in hex format
└── README.md # This file

## Build and Run Instructions

### Simulation with ModelSim/Questasim
```bash
# Compile the design
vlog src/riscvsingle.sv

# Run simulation  
vsim -c testbench -do "run -all"

# Or with GUI
vsim testbench

Expected Output :
When simulation succeeds, you should see:
Simulation succeeded