# Problem 3 (Mealy): Vending Machine with Change

## Goal
- **Price:** 20  
- **Accepted coins:** 5 or 10 (`coin[1:0] = 01 → 5, 10 → 10`)  
- **Ignore:** `00` (idle) and `11` (invalid)  
- **Outputs:**
  - `dispense = 1` for 1 cycle when total ≥ 20  
  - If total = 25, also `chg5 = 1` for 1 cycle (return 5)  
- **Reset:** synchronous, active-high  
- **Type:** Mealy FSM  

---

## State Diagram (Mealy)

**States (running total):**
- **S0:** total = 0  
- **S5:** total = 5  
- **S10:** total = 10  
- **S15:** total = 15  

**Transitions & Outputs:**
- `S0 --01/----> S5`  
- `S0 --10/----> S10`  
- `S5 --01/----> S10`  
- `S5 --10/----> S15`  
- `S10 --01/---> S15`  
- `S10 --10/dispense=1--> S0`  
- `S15 --01/dispense=1--> S0`  
- `S15 --10/dispense=1,chg5=1--> S0`  

*(Inputs `00` and `11` are ignored — self-loops with no output.)*

---

## Justification for Mealy

- **Outputs depend on both state and input.**  
  - Example: In **S10**, if input = `10`, the machine *immediately* outputs `dispense=1` in the same cycle.  
- This ensures **1-cycle pulses** exactly when a coin completes the required price.  
- A Moore machine would need extra states to delay outputs by one cycle, which is inefficient.  
- Therefore, a **Mealy FSM** is the natural and minimal choice for this design.  

---

## Waveform Verification

The waveform simulation (GTKWave) validates correct FSM behavior.  
Key markers:

- **Marker D:** Sequence `10 + 10 = 20` → `dispense=1` (one cycle).  
- **Marker B:** Sequence `5 + 5 + 5 + 5 = 20` → `dispense=1` (one cycle).  
- **Marker C:** Sequence `5 + 10 + 10 = 25` → `dispense=1` and `chg5=1` (one cycle each).  
- **Marker E:** Input `11` ignored → no outputs.  

All outputs are **1-cycle wide pulses**, confirming correct Mealy behavior.

---

