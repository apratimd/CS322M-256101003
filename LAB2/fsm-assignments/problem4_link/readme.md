# Master–Slave 4-Phase Handshake (Verilog)

Using **Icarus Verilog** and **GTKWave**:

```bash
# Compile
iverilog -g2012 -o link.vvp master_fsm.v slave_fsm.v link_top.v tb_link_top.v

# Run simulation
vvp link.vvp

# Open waveform
gtkwave link.vcd 

The waveform should show four complete handshakes, each following the 4-phase sequence:
req↑ → ack↑ → req↓ → ack↓.

On every req↑, the Master drives a new data byte (A0, A1, A2, A3), and the Slave latches this value into last_byte.

The Slave holds ack=1 for two clock cycles after each req↑, and only drops ack once req is LOW.

After the fourth data transfer, the Master asserts done=1 for exactly one cycle, indicating the burst is complete.
