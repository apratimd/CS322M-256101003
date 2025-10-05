# RVX10 Encodings (CUSTOM-0, R-type)

All RVX10 instructions use opcode **0x0B (0001011)** and the R-type shape【59†source】:

```
31..25   24..20  19..15 14..12 11..7  6..0
funct7 |   rs2 |   rs1 | funct3|  rd | opcode
```

**Machine code (unsigned)**:  
`inst = (funct7<<25) | (rs2<<20) | (rs1<<15) | (funct3<<12) | (rd<<7) | 0x0B`【59†source】

| Instr | funct7   | funct3 | Semantics (32‑bit) |
|------|----------|--------|---------------------|
| ANDN | 0000000  | 000    | `rd = rs1 & ~rs2` |
| ORN  | 0000000  | 001    | `rd = rs1 \| ~rs2` |
| XNOR | 0000000  | 010    | `rd = ~(rs1 ^ rs2)` |
| MIN  | 0000001  | 000    | signed min |
| MAX  | 0000001  | 001    | signed max |
| MINU | 0000001  | 010    | unsigned min |
| MAXU | 0000001  | 011    | unsigned max |
| ROL  | 0000010  | 000    | `s = rs2[4:0]` |
| ROR  | 0000010  | 001    | `s = rs2[4:0]` |
| ABS  | 0000011  | 000    | `rs2 = x0`; hardware ignores `rs2`【59†source】 |

### Worked encodings

**Example 1: `ANDN x5, x6, x7`**  
- `funct7=0000000`, `rs2=7`, `rs1=6`, `funct3=000`, `rd=5`, `opcode=0x0B`  
- `inst = (0<<25)|(7<<20)|(6<<15)|(0<<12)|(5<<7)|0x0B = 0x00E3028B`

**Example 2: `MIN x3, x1, x2`**  
- `funct7=0000001`, `funct3=000`, `rd=3`, `rs1=1`, `rs2=2`, `opcode=0x0B`  
- `inst = (1<<25)|(2<<20)|(1<<15)|(0<<12)|(3<<7)|0x0B = 0x0220818B`

**Example 3: `ABS x6, x2`** (encode as `R` with `rs2=x0`)  
- `funct7=0000011`, `funct3=000`, `rd=6`, `rs1=2`, `rs2=0`, `opcode=0x0B`  
- `inst = (3<<25)|(0<<20)|(2<<15)|(0<<12)|(6<<7)|0x0B = 0x0601030B`

> See the assignment PDF for the full table and notes about rotate‑by‑0 and INT_MIN behavior【59†source】.
