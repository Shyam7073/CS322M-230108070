# RVX10-P: Five-Stage Pipelined RISC-V Core

## Design Description

This project implements a five-stage pipelined RISC-V processor supporting RV32I base instructions and 10 custom RVX10 ALU instructions. The pipeline stages are:

1. IF : Fetches instruction from memory
2. ID : Decodes instruction and reads registers
3. EX : Performs ALU operations
4. MEM: Accesses data memory
5. WB: Writes results back to register file

## Hazard Handling

### Data Hazards
- Forwarding: Implemented from MEM and WB stages to EX stage inputs
- Load-Use Stalls: Detected when EX stage needs data from a load in MEM stage

### Control Hazards  
- Branch Prediction: Always predict not taken
- Branch Flush: Flush IF/ID register when branch is taken in EX stage

