# README: Overlapping Sequence Detector (Mealy FSM)

## Goal  
Design a Mealy FSM to detect the serial bit pattern **1101** on input `din` with **overlap**.  
- Output `y` is a **1-cycle pulse** when the last bit of the sequence arrives.  
- Reset: **synchronous, active-high**.  



### 1. Waveform (Simulation Evidence)  
- Signals: `clk`, `rst`, `din`, `y`.  
- **Markers placed** at detection cycles where `y = 1`.  
- Each detection corresponds to the completion of pattern **1101**.  

---

### 2. Test Stream and Detection Results  

**Bitstream tested:**  
```
11011011101
```

**Indexing convention:**  
- Index **0** = first bit applied after reset release.  
- One bit driven per rising clock edge.  

**Expected detections:**  
- Pattern `1101` ends at indices: **3, 6, 10**.  
- Therefore, output `y` pulses at:  
  - **65 ns** (index 3)  
  - **95 ns** (index 6)  
  - **135 ns** (index 10)  

---

## Summary  
- FSM correctly detects `1101` with **overlap**.  
- Output `y` produces **1-cycle pulses** at detection instants.  
- Verified with simulation in GTKWave; markers set at detection points.  
