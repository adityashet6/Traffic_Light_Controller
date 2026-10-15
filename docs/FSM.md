# Finite-State Machine

```text
       +---- S0: J1 GREEN ----+
       |                      v
S5: J3 YELLOW <- S4: J3 GREEN <- S3: J2 YELLOW <- S2: J2 GREEN
       ^                                               ^
       |                                               |
       +---------------- S1: J1 YELLOW <---------------+
```

Intended sequence:

`S0 -> S1 -> S2 -> S3 -> S4 -> S5 -> S0`

Green states last `GREEN_SECONDS`; yellow states last `YELLOW_SECONDS`.
At every state, only one junction is permitted to show green or yellow;
the other two junctions remain red.
