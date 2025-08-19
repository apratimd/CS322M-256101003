# Traffic Light Controller (FSM with Tick Integration)

## Clock and Tick Details
- **System Clock (clk):** 10 MHz (period = 100 ns).
- **Tick Signal (tick):**
  - Derived from the main clock.
  - **One-cycle wide pulse**, evenly spaced.
  - Verified in waveform: `tick` rises every **1 µs**.
  - Therefore, **TICK_HZ = 1 MHz**.

## FSM Operation
- FSM runs on `clk`, but the **phase counter increments only on `tick`**.
- Four traffic light phases are used, with durations defined in **tick counts**:
  1. **North-South Green (5 ticks)** → 5 µs  
  2. **North-South Yellow (2 ticks)** → 2 µs  
  3. **East-West Green (5 ticks)** → 5 µs  
  4. **East-West Yellow (2 ticks)** → 2 µs  

## Verification in Waveform
- From the simulation (`traffic_light_tb.vcd` viewed in GTKWave):
  - The `tick` signal is **1 µs periodic** (1 MHz).
  - Each state transition occurs only after the required number of ticks:
    - **5 ticks → 5 µs** green phase.
    - **2 ticks → 2 µs** yellow phase.
    - Sequence repeats as 5/2/5/2 ticks.
- Waveform confirms that the FSM respects the intended durations.

## Summary
- **Clock frequency:** 10 MHz  
- **Tick frequency (TICK_HZ):** 1 MHz  
- **Phase durations:** Verified as 5/2/5/2 ticks → 5/2/5/2 µs.  
- FSM logic and tick integration validated in simulation.
