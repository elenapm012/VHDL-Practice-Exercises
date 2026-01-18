# Design and implementation of a fully synthesizable RS-232 receiver in VHDL using a finite state machine (FSM).

The receiver follows the standard RS-232 frame format, where the serial line remains at logic high when idle and reception starts upon detection of a falling edge ('1' to '0') corresponding to the start bit. A synchronization flag (FLAG) is asserted to initiate data reception.

The design supports configurable frame parameters, allowing the number of data bits (8 or 9) and the number of stop bits (one or two) to be selected. Odd parity is implemented for error detection.

The system operates with a 1 Hz clock and a reception rate of 1 bit per second (1 bps). The entire design is fully synthesizable and implemented using an FSM-based control architecture.
