# RVX10 Test Plan

**Harness rule:** At end of the program, store **25** to memory address **100**; the provided testbench prints “Simulation succeeded”.

## Strategy
- For each op, compute deterministic results and optionally fold into a checksum register (e.g., `x28`).
- Exercise corner cases:
  - **ROL/ROR:** `shamt = 0` and `31` (return `rs1` when `0`)
  - **ABS:** `INT_MIN = 0x8000_0000` ⇒ result is `0x8000_0000` (two’s‑complement wrap; no traps)
  - **MIN/MAX vs MINU/MAXU:** signed vs unsigned comparisons around `0x8000_0000` and `0xFFFF_FFFF`

## Example vectors
- ANDN: `rs1=0xF0F0_A5A5`, `rs2=0x0F0F_FFFF` → `0xF0F0_0000`  
- MINU: `rs1=0xFFFF_FFFE`, `rs2=0x0000_0001` → `0x0000_0001`  
- ROL: `rs1=0x8000_0001`, `s=3` → `0x0000_000B`  
- ABS: `rs1=-128` → `0x0000_0080`

## Diagnostics (optional)
Store intermediate results at addresses `[96 + 4*i]` for quick inspection, then **store 25 to 100** to pass.
