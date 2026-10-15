`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Traffic Light Controller (TLC)
// Platform: Xilinx Vivado / FPGA
//
// Three-junction, six-state finite-state machine.
// Outputs are encoded as {Red, Yellow, Green} for each junction.
//
// Default timing assumes a 50 MHz clock:
//   Green  = 5 seconds
//   Yellow = 2 seconds
//
// Change CLK_FREQ_HZ, GREEN_SECONDS, or YELLOW_SECONDS to suit your clock
// or desired simulation/implementation timing.
//////////////////////////////////////////////////////////////////////////////////

module traffic_controller #(
    parameter integer CLK_FREQ_HZ  = 50000000,
    parameter integer GREEN_SECONDS = 5,
    parameter integer YELLOW_SECONDS = 2
)(
    input  wire       clk,
    input  wire       reset,
    output reg  [2:0] j1,
    output reg  [2:0] j2,
    output reg  [2:0] j3
);

    // Light encoding: {Red, Yellow, Green}
    localparam [2:0] RED    = 3'b100;
    localparam [2:0] YELLOW = 3'b010;
    localparam [2:0] GREEN  = 3'b001;

    // Six FSM states: each junction gets green, then yellow.
    localparam [2:0] S0 = 3'd0; // J1 green
    localparam [2:0] S1 = 3'd1; // J1 yellow
    localparam [2:0] S2 = 3'd2; // J2 green
    localparam [2:0] S3 = 3'd3; // J2 yellow
    localparam [2:0] S4 = 3'd4; // J3 green
    localparam [2:0] S5 = 3'd5; // J3 yellow

    localparam integer GREEN_CYCLES  = CLK_FREQ_HZ * GREEN_SECONDS;
    localparam integer YELLOW_CYCLES = CLK_FREQ_HZ * YELLOW_SECONDS;
    localparam integer MAX_CYCLES =
        (GREEN_CYCLES > YELLOW_CYCLES) ? GREEN_CYCLES : YELLOW_CYCLES;
    localparam integer COUNT_WIDTH =
        (MAX_CYCLES <= 1) ? 1 : $clog2(MAX_CYCLES);

    reg [2:0] state;
    reg [COUNT_WIDTH-1:0] timer;
    reg [COUNT_WIDTH-1:0] state_duration;

    // State register and per-state timer.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= {COUNT_WIDTH{1'b0}};
        end else begin
            if (timer >= state_duration - 1) begin
                timer <= {COUNT_WIDTH{1'b0}};
                case (state)
                    S0: state <= S1;
                    S1: state <= S2;
                    S2: state <= S3;
                    S3: state <= S4;
                    S4: state <= S5;
                    S5: state <= S0;
                    default: state <= S0;
                endcase
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    // Select the duration for the active state.
    always @(*) begin
        case (state)
            S0, S2, S4: state_duration = GREEN_CYCLES;
            S1, S3, S5: state_duration = YELLOW_CYCLES;
            default:   state_duration = GREEN_CYCLES;
        endcase
    end

    // Safe output decode: all junctions default to red.
    always @(*) begin
        j1 = RED;
        j2 = RED;
        j3 = RED;

        case (state)
            S0: begin j1 = GREEN;  j2 = RED;    j3 = RED;    end
            S1: begin j1 = YELLOW; j2 = RED;    j3 = RED;    end
            S2: begin j1 = RED;    j2 = GREEN;  j3 = RED;    end
            S3: begin j1 = RED;    j2 = YELLOW; j3 = RED;    end
            S4: begin j1 = RED;    j2 = RED;    j3 = GREEN;  end
            S5: begin j1 = RED;    j2 = RED;    j3 = YELLOW; end
            default: begin j1 = RED; j2 = RED; j3 = RED; end
        endcase
    end

endmodule
