`timescale 1ns/1ps

module car_indicator_controller #(
    parameter integer BLINK_COUNT = 5
)(
    input  wire clk,
    input  wire reset,

    // Sensor inputs
    input  wire left_sensor,
    input  wire right_sensor,

    // Indicator outputs
    output reg left_indicator,
    output reg right_indicator
);

    integer count;

    /*
     * Blink counter
     *
     * The counter is intentionally small for simulation.
     * BLINK_COUNT can be increased for FPGA implementation.
     */
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            count <= 0;
        end
        else begin
            if (count >= BLINK_COUNT - 1)
                count <= 0;
            else
                count <= count + 1;
        end

    end

    /*
     * Indicator control
     */
    always @(*) begin

        // Default state
        left_indicator  = 1'b0;
        right_indicator = 1'b0;

        /*
         * Both sensors active:
         * Hazard warning mode.
         * Both indicators blink together.
         */
        if (left_sensor && right_sensor) begin

            left_indicator  = (count < BLINK_COUNT / 2);
            right_indicator = (count < BLINK_COUNT / 2);

        end

        /*
         * Left sensor active:
         * Left indicator blinks.
         */
        else if (left_sensor) begin

            left_indicator  = (count < BLINK_COUNT / 2);
            right_indicator = 1'b0;

        end

        /*
         * Right sensor active:
         * Right indicator blinks.
         */
        else if (right_sensor) begin

            left_indicator  = 1'b0;
            right_indicator = (count < BLINK_COUNT / 2);

        end

        /*
         * No sensor active:
         * Both indicators OFF.
         */
        else begin

            left_indicator  = 1'b0;
            right_indicator = 1'b0;

        end

    end

endmodule