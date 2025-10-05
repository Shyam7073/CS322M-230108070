# RVX10 Test Plan

## Test Strategy
Each instruction will be tested with multiple input combinations and results will be accumulated in register x28 as a checksum. Final success is indicated by storing value 25 to memory address 100.

## Test Cases

### 1. ANDN (AND NOT)
**Inputs:**
- Test 1: rs1 = 0xF0F0A5A5, rs2 = 0x0F0FFFFF
- Test 2: rs1 = 0xFFFFFFFF, rs2 = 0x55555555
- Test 3: rs1 = 0x00000000, rs2 = 0xFFFFFFFF

**Expected Results:**
- Result 1: 0xF0F00000
- Result 2: 0xAAAAAAAA  
- Result 3: 0x00000000

### 2. ORN (OR NOT)
**Inputs:**
- Test 1: rs1 = 0xF0F0A5A5, rs2 = 0x0F0FFFFF
- Test 2: rs1 = 0x55555555, rs2 = 0xFFFFFFFF

**Expected Results:**
- Result 1: 0xF0F0A5A5
- Result 2: 0xFFFFFFFF

### 3. XNOR
**Inputs:**
- Test 1: rs1 = 0x55555555, rs2 = 0x55555555
- Test 2: rs1 = 0xAAAAAAAA, rs2 = 0x55555555

**Expected Results:**
- Result 1: 0xFFFFFFFF
- Result 2: 0x00000000

### 4. MIN (Signed Minimum)
**Inputs:**
- Test 1: rs1 = -5, rs2 = 10
- Test 2: rs1 = 100, rs2 = -200

**Expected Results:**
- Result 1: -5 (0xFFFFFFFB)
- Result 2: -200 (0xFFFFFF38)

### 5. MAX (Signed Maximum)
**Inputs:**
- Test 1: rs1 = -5, rs2 = 10
- Test 2: rs1 = 100, rs2 = -200

**Expected Results:**
- Result 1: 10 (0x0000000A)
- Result 2: 100 (0x00000064)

### 6. MINU (Unsigned Minimum)
**Inputs:**
- Test 1: rs1 = 0xFFFFFFFE, rs2 = 0x00000001
- Test 2: rs1 = 0x0000000A, rs2 = 0x00000014

**Expected Results:**
- Result 1: 0x00000001
- Result 2: 0x0000000A

### 7. MAXU (Unsigned Maximum)
**Inputs:**
- Test 1: rs1 = 0xFFFFFFFE, rs2 = 0x00000001
- Test 2: rs1 = 0x0000000A, rs2 = 0x00000014

**Expected Results:**
- Result 1: 0xFFFFFFFE
- Result 2: 0x00000014

### 8. ROL (Rotate Left)
**Inputs:**
- Test 1: rs1 = 0x80000001, rs2 = 3
- Test 2: rs1 = 0x12345678, rs2 = 8
- Test 3: rs1 = 0xABCDEF01, rs2 = 0 (no shift)

**Expected Results:**
- Result 1: 0x0000000B
- Result 2: 0x34567812
- Result 3: 0xABCDEF01

### 9. ROR (Rotate Right)
**Inputs:**
- Test 1: rs1 = 0x0000000B, rs2 = 3
- Test 2: rs1 = 0x12345678, rs2 = 8
- Test 3: rs1 = 0xABCDEF01, rs2 = 0 (no shift)

**Expected Results:**
- Result 1: 0x80000001
- Result 2: 0x78123456
- Result 3: 0xABCDEF01

### 10. ABS (Absolute Value)
**Inputs:**
- Test 1: rs1 = -128 (0xFFFFFF80)
- Test 2: rs1 = 255 (0x000000FF)
- Test 3: rs1 = -2147483648 (0x80000000) - INT_MIN edge case

**Expected Results:**
- Result 1: 128 (0x00000080)
- Result 2: 255 (0x000000FF)
- Result 3: 0x80000000 (INT_MIN remains unchanged)

## Success Criteria
- All instructions produce expected results
- Checksum in x28 matches expected value
- Final store of 25 to address 100 executes
- "Simulation succeeded" message displayed