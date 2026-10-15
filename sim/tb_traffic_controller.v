```verilog
`timescale 1ns / 1ps

module tb_traffic_controller;

    reg clk;
    reg reset;

    wire [2:0] traffic_light_1;
    wire [2:0] traffic_light_2;
    wire [2:0] traffic_light_3;

    // Short timings for simulation
    traffic_controller #(
        .CLK_FREQ_HZ(10),
        .GREEN_SECONDS(5),
        .YELLOW_SECONDS(2)
    ) dut (
        .clk(clk),
        .reset(reset),
        .traffic_light_1(traffic_light_1),
        .traffic_light_2(traffic_light_2),
        .traffic_light_3(traffic_light_3)
    );

    // 10 ns clock period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        #20;
        reset = 0;

        // Observe multiple traffic-light transitions
        #500;
        $finish;
    end

    initial begin
        $monitor(
            "Time=%0t | Light1=%b | Light2=%b | Light3=%b",
            $time,
            traffic_light_1,
            traffic_light_2,
            traffic_light_3
        );
    end

endmodule
```
