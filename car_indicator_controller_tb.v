`timescale 1ns/1ps

module car_indicator_controller_tb;

    reg clk;
    reg reset;

    reg left_sensor;
    reg right_sensor;

    wire left_indicator;
    wire right_indicator;

    /*
     * Instantiate the design
     */
    car_indicator_controller #(
        .BLINK_COUNT(5)
    ) uut (
        .clk(clk),
        .reset(reset),

        .left_sensor(left_sensor),
        .right_sensor(right_sensor),

        .left_indicator(left_indicator),
        .right_indicator(right_indicator)
    );

    /*
     * Clock generation
     * 10 ns clock period
     */
    always #5 clk = ~clk;

    /*
     * Monitor signals
     */
    initial begin
        $monitor(
            "TIME=%0t | LeftSensor=%b | RightSensor=%b | LeftIndicator=%b | RightIndicator=%b | Counter=%0d",
            $time,
            left_sensor,
            right_sensor,
            left_indicator,
            right_indicator,
            uut.count
        );
    end

    /*
     * Generate waveform
     */
    initial begin
        $dumpfile("car_indicator.vcd");
        $dumpvars(0, car_indicator_controller_tb);
    end

    /*
     * Test sequence
     */
    initial begin

        // Initial values
        clk = 1'b0;
        reset = 1'b1;
        left_sensor = 1'b0;
        right_sensor = 1'b0;

        $display("==============================================");
        $display("       CAR INDICATOR CONTROLLER TEST          ");
        $display("==============================================");

        /*
         * Reset
         */
        #12;
        reset = 1'b0;

        $display("\nTEST 1: No sensors active");
        left_sensor = 1'b0;
        right_sensor = 1'b0;

        #30;

        /*
         * Left sensor
         */
        $display("\nTEST 2: Left sensor active");
        left_sensor = 1'b1;
        right_sensor = 1'b0;

        #80;

        /*
         * Right sensor
         */
        $display("\nTEST 3: Right sensor active");
        left_sensor = 1'b0;
        right_sensor = 1'b1;

        #80;

        /*
         * Hazard mode
         */
        $display("\nTEST 4: Both sensors active - HAZARD MODE");
        left_sensor = 1'b1;
        right_sensor = 1'b1;

        #80;

        /*
         * Return to normal
         */
        $display("\nTEST 5: Sensors inactive");
        left_sensor = 1'b0;
        right_sensor = 1'b0;

        #30;

        /*
         * End simulation
         */
        $display("\n==============================================");
        $display("         SIMULATION COMPLETED                 ");
        $display("==============================================");

        $finish;

    end

endmodule