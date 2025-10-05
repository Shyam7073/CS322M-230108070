# RVX10 Instruction Encodings

## Instruction Format
All RVX10 instructions use R-type format with opcode = 0x0B (CUSTOM-0)

Machine code format: `inst = (funct7<<25) | (rs2<<20) | (rs1<<15) | (funct3<<12) | (rd<<7) | opcode`

## RVX10 Instruction Encoding Table

| Instruction | opcode (hex) | funct7 (binary) | funct3 (binary) | rs2 usage          |
|-------------|--------------|-----------------|-----------------|-------------------|
| ANDN        | 0x0B         | 0000000         | 000             | rs2               |
| ORN         | 0x0B         | 0000000         | 001             | rs2               |
| XNOR        | 0x0B         | 0000000         | 010             | rs2               |
| MIN         | 0x0B         | 0000001         | 000             | rs2               |
| MAX         | 0x0B         | 0000001         | 001             | rs2               |
| MINU        | 0x0B         | 0000001         | 010             | rs2               |
| MAXU        | 0x0B         | 0000001         | 011             | rs2               |
| ROL         | 0x0B         | 0000010         | 000             | rs2[4:0] for shamt |
| ROR         | 0x0B         | 0000010         | 001             | rs2[4:0] for shamt |
| ABS         | 0x0B         | 0000011         | 000             | ignored (set rs2=x0) |

## Worked Encoding Examples

### Example 1: ANDN x5, x6, x7
**Field Values:**
- opcode = 0x0B = 0001011 (binary)
- rd = x5 = 5 = 00101 (binary)
- funct3 = 000 (binary)
- rs1 = x6 = 6 = 00110 (binary) 
- rs2 = x7 = 7 = 00111 (binary)
- funct7 = 0000000 (binary)

**Bitfield Construction:**
| funct7 | rs2 | rs1 | funct3 | rd | opcode |
| 0000000 | 00111 | 00110 | 000 | 00101 | 0001011 |
| 31-25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |

**Calculation:**
inst = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
= (0x00 << 25) | (7 << 20) | (6 << 15) | (0 << 12) | (5 << 7) | 0x0B
= 0x00000000 | 0x00700000 | 0x00030000 | 0x00000000 | 0x00000280 | 0x0000000B
= 0x0073028B

**Verification:**
- Binary: `0000000_00111_00110_000_00101_0001011`
- Hex: `0x0073028B`

### Example 2: ABS x10, x11
**Field Values:**
- opcode = 0x0B = 0001011 (binary)
- rd = x10 = 10 = 01010 (binary)
- funct3 = 000 (binary)
- rs1 = x11 = 11 = 01011 (binary)
- rs2 = x0 = 0 = 00000 (binary) - ignored for ABS
- funct7 = 0000011 (binary)

**Bitfield Construction:**
| funct7 | rs2 | rs1 | funct3 | rd | opcode |
| 0000011 | 00000 | 01011 | 000 | 01010 | 0001011 |
| 31-25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |

**Calculation:**
inst = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
= (0x03 << 25) | (0 << 20) | (11 << 15) | (0 << 12) | (10 << 7) | 0x0B
= 0x06000000 | 0x00000000 | 0x00058000 | 0x00000000 | 0x00000500 | 0x0000000B
= 0x0605850B

**Verification:**
- Binary: `0000011_00000_01011_000_01010_0001011`
- Hex: `0x0605850B`

### Example 3: ROL x12, x13, x14
**Field Values:**
- opcode = 0x0B = 0001011 (binary)
- rd = x12 = 12 = 01100 (binary)
- funct3 = 000 (binary)
- rs1 = x13 = 13 = 01101 (binary)
- rs2 = x14 = 14 = 01110 (binary) - only bits [4:0] used for shift amount
- funct7 = 0000010 (binary)

**Bitfield Construction:**
| funct7 | rs2 | rs1 | funct3 | rd | opcode |
| 0000010 | 01110 | 01101 | 000 | 01100 | 0001011 |
| 31-25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |

**Calculation:**
inst = (funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
= (0x02 << 25) | (14 << 20) | (13 << 15) | (0 << 12) | (12 << 7) | 0x0B
= 0x04000000 | 0x00E00000 | 0x00068000 | 0x00000000 | 0x00000600 | 0x0000000B
= 0x04E6860B


**Verification:**
- Binary: `0000010_01110_01101_000_01100_0001011`
- Hex: `0x04E6860B`

### Example 4: MIN x15, x16, x17
**Field Values:**
- opcode = 0x0B = 0001011 (binary)
- rd = x15 = 15 = 01111 (binary)
- funct3 = 000 (binary)
- rs1 = x16 = 16 = 10000 (binary)
- rs2 = x17 = 17 = 10001 (binary)
- funct7 = 0000001 (binary)

**Calculation:**
inst = (0x01 << 25) | (17 << 20) | (16 << 15) | (0 << 12) | (15 << 7) | 0x0B
= 0x02000000 | 0x01100000 | 0x00080000 | 0x00000000 | 0x00000780 | 0x0000000B
= 0x0318078B

**Verification:**
- Binary: `0000001_10001_10000_000_01111_0001011`
- Hex: `0x0318078B`
