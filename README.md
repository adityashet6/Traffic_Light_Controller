# Traffic Light Controller (TLC)

A three-junction traffic light controller implemented in **Verilog HDL** as a
six-state finite-state machine, intended for use with **Xilinx Vivado and an
FPGA**.

## Behaviour

The junction outputs are three-bit values encoded as `{Red, Yellow, Green}`:

| Value | Meaning |
|---|---|
| `3'b100` | Red |
| `3'b010` | Yellow |
| `3'b001` | Green |

The controller sequences through these states:

1. `S0`: J1 green; J2 and J3 red
2. `S1`: J1 yellow; J2 and J3 red
3. `S2`: J2 green; J1 and J3 red
4. `S3`: J2 yellow; J1 and J3 red
5. `S4`: J3 green; J1 and J2 red
6. `S5`: J3 yellow; J1 and J2 red
7. Return to `S0` and repeat

The default parameters assume a 50 MHz clock, with 5 seconds of green and
2 seconds of yellow per junction. The timing parameters can be changed for a
different FPGA clock or for faster simulation.

## Folder structure

```text
Traffic_Light_Controller/
├── rtl/
│   └── traffic_controller.v
├── sim/
│   └── tb_traffic_controller.v
├── docs/
│   └── FSM.md
├── .gitignore
└── README.md
```

## Open in Vivado

1. Create a new RTL project named `Traffic_Light_Controller`.
2. Add `rtl/traffic_controller.v` as a **Design Source**.
3. Add `sim/tb_traffic_controller.v` as a **Simulation Source**.
4. Select `tb_traffic_controller` as the simulation top.
5. Run **Behavioral Simulation** and inspect `j1`, `j2`, and `j3`.

This repository does not include a board-specific `.xdc` constraints file because
the target FPGA board and physical pin assignments were not specified. Add an
appropriate `.xdc` before programming a physical board.

## Parameters

| Parameter | Default | Purpose |
|---|---:|---|
| `CLK_FREQ_HZ` | `50000000` | Input clock frequency in Hz |
| `GREEN_SECONDS` | `5` | Green interval in seconds |
| `YELLOW_SECONDS` | `2` | Yellow interval in seconds |

## Notes

- `reset` is active-high and asynchronous.
- The default output decode is all-red for an invalid FSM state.
- The supplied testbench uses shortened timing to make simulation practical.
- This is a reconstructed project package based on the earlier project details;
  run simulation in your Vivado setup before treating it as a verified release.
