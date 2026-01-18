# Design and implementation of a fully synthesizable up/down seconds counter in VHDL operating at a 25 MHz system clock

The system supports both ascending and descending counting modes, selectable via a mode switch. In up-counting mode, the counter increments from 0 to 59 seconds, while in down-counting mode it decrements from 59 to 0 seconds. When the counter reaches its limit, the counting process stops and a FULL output signal is asserted.

A start/stop control allows the counter to be paused and resumed via a switch input, while a reset input initializes the system. The current seconds count is displayed using a 7-segment display for the units digit, and a set of six LEDs is used to represent the tens digit, interfacing directly with external FPGA hardware.

The design is fully synthesizable and integrates sequential logic, control signals, and output decoding for both display types.