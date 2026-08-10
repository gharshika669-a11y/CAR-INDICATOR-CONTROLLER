# Car Indicator Controller Using Verilog HDL

## Overview

This project implements a **sensor-based car indicator controller** using Verilog HDL.

The controller receives signals from two sensors:

* Left sensor
* Right sensor

Based on the sensor inputs, the controller activates the corresponding car indicators.

The design supports three main operating modes:

1. Left-turn indication
2. Right-turn indication
3. Hazard warning

When both sensors are active simultaneously, both indicators flash together to represent hazard mode.

## Features

* Sensor-based control
* Left indicator control
* Right indicator control
* Hazard warning mode
* Automatic blinking
* Synchronous clock-based operation
* Active-high reset
* Synthesizable Verilog RTL
* Complete simulation testbench
* VCD waveform generation

## Block Diagram

```text
                 +----------------------+
                 |                      |
 Left Sensor --->|                      |---> Left Indicator
                 |                      |
 Right Sensor -->|  Car Indicator       |---> Right Indicator
                 |     Controller       |
 Clock --------->|                      |
 Reset --------->|                      |
                 |                      |
                 +----------------------+
```

## Input Signals

| Signal         | Width | Description       |
| -------------- | ----: | ----------------- |
| `clk`          | 1 bit | System clock      |
| `reset`        | 1 bit | Active-high reset |
| `left_sensor`  | 1 bit | Left-turn sensor  |
| `right_sensor` | 1 bit | Right-turn sensor |

## Output Signals

| Signal            | Width | Description            |
| ----------------- | ----: | ---------------------- |
| `left_indicator`  | 1 bit | Left indicator output  |
| `right_indicator` | 1 bit | Right indicator output |

## Operating Modes

### Mode 1: Normal

When neither sensor is active:

```text
left_sensor  = 0
right_sensor = 0
```

Both indicators remain OFF.

```text
Left Indicator  = 0
Right Indicator = 0
```

### Mode 2: Left Turn

When only the left sensor is active:

```text
left_sensor  = 1
right_sensor = 0
```

The left indicator flashes.

```text
Left Indicator  = BLINK
Right Indicator = OFF
```

### Mode 3: Right Turn

When only the right sensor is active:

```text
left_sensor  = 0
right_sensor = 1
```

The right indicator flashes.

```text
Left Indicator  = OFF
Right Indicator = BLINK
```

### Mode 4: Hazard Warning

When both sensors are active:

```text
left_sensor  = 1
right_sensor = 1
```

Both indicators flash simultaneously.

```text
Left Indicator  = BLINK
Right Indicator = BLINK
```

## Truth Table

| Left Sensor | Right Sensor | Operating Mode | Left Indicator | Right Indicator |
| ----------: | -----------: | -------------- | -------------- | --------------- |
|           0 |            0 | Normal         | OFF            | OFF             |
|           0 |            1 | Right Turn     | OFF            | BLINK           |
|           1 |            0 | Left Turn      | BLINK          | OFF             |
|           1 |            1 | Hazard         | BLINK          | BLINK           |

## Blinking Operation

The controller uses a clock counter to create a blinking signal.

For simulation, a small counter is used so that the blinking behavior can easily be observed.

The counter repeatedly cycles through its range:

```text
0 → 1 → 2 → 3 → 4 → 0 → ...
```

The indicator is ON during one portion of the counter cycle and OFF during the other portion.

For an actual vehicle/FPGA implementation, the `BLINK_COUNT` parameter can be increased to produce a slower and more visible indicator flash.

## RTL Architecture

The controller consists of two major functions:

### 1. Blink Counter

The counter runs using the system clock and generates the timing required for the indicator flashing.

### 2. Indicator Controller

The controller examines the sensor inputs and selects the appropriate indicator mode.

```text
              Sensor Inputs
                    |
             +------+------+
             |             |
        Left Sensor    Right Sensor
             |             |
             +------+------+
                    |
              Mode Selection
                    |
          +---------+---------+
          |         |         |
        Left      Right     Hazard
        Turn      Turn       Mode
          |         |         |
          +---------+---------+
                    |
              Blink Control
                    |
             +------+------+
             |             |
       Left Indicator  Right Indicator
```

## File Structure

```text
car-indicator-controller/
│
├── README.md
│
├── src/
│   └── car_indicator_controller.v
│
├── tb/
│   └── car_indicator_controller_tb.v
│
└── simulation/
    └── simulation_output.txt
```

## Simulation

The testbench verifies the following conditions:

1. Reset operation
2. No sensor active
3. Left sensor active
4. Right sensor active
5. Both sensors active
6. Indicator blinking
7. Return to normal operation

## Icarus Verilog

Compile the design:

```bash
iverilog -o car_indicator_sim src/car_indicator_controller.v tb/car_indicator_controller_tb.v
```

Run the simulation:

```bash
vvp car_indicator_sim
```

A waveform file named `car_indicator.vcd` will be generated.

Open the waveform using GTKWave:

```bash
gtkwave car_indicator.vcd
```

## ModelSim / QuestaSim

Compile:

```text
vlog src/car_indicator_controller.v
vlog tb/car_indicator_controller_tb.v
```

Run:

```text
vsim car_indicator_controller_tb
run -all
```

## Expected Waveform

During left-sensor activation:

```text
left_sensor      ────████████████────
right_sensor     ────────────────────
left_indicator   ────██──██──██──────
right_indicator  ────────────────────
```

During right-sensor activation:

```text
left_sensor      ────────────────────
right_sensor     ────████████████────
left_indicator   ────────────────────
right_indicator  ────██──██──██──────
```

During hazard mode:

```text
left_sensor      ────████████████────
right_sensor     ────████████████────
left_indicator   ────██──██──██──────
right_indicator  ────██──██──██──────
```

## Test Cases

| Test | Left Sensor | Right Sensor | Expected Result |
| ---- | ----------: | -----------: | --------------- |
| 1    |           0 |            0 | Both OFF        |
| 2    |           1 |            0 | Left BLINK      |
| 3    |           0 |            1 | Right BLINK     |
| 4    |           1 |            1 | Both BLINK      |
| 5    |           0 |            0 | Both OFF        |

## Advantages

* Simple RTL architecture
* Low hardware complexity
* Easy to implement on an FPGA
* Supports automatic blinking
* Supports hazard mode
* Easy to expand with additional sensors

## Future Enhancements

The project can be extended with:

* Brake-light control
* Emergency braking detection
* Vehicle speed input
* Steering-angle sensor
* PWM-based indicator timing
* Seven-segment display
* LCD display
* Debouncing for mechanical sensors
* Fault detection
* FPGA board implementation
* CAN-bus interface
* Automotive-grade state-machine control

## Conclusion

The Car Indicator Controller demonstrates the use of Verilog HDL to design a simple automotive control system.

The system uses sensor inputs to determine whether the vehicle is turning left, turning right, or entering hazard mode. A clock-based counter provides the blinking functionality required for the indicators.

The project includes RTL code, a testbench, simulation output, and waveform generation, making it suitable for FPGA/Verilog simulation and academic project demonstration.
