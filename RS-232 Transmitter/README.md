# Design and implementation of a fully synthesizable RS-232 transmitter in VHDL using a finite state machine (FSM).

The transmitter follows the standard RS-232 frame format, where the serial line remains at logic high when idle, transmission starts with a start bit (0), followed by 8 data bits, an odd parity bit, and a stop bit (1).

The system operates with a 1 Hz clock signal, resulting in a transmission rate of 1 bit per second (1 bps). All inputs are synchronous, and once transmission has started, it cannot be interrupted.

Control signals include Load to load and transmit data, TxBusy to indicate an ongoing transmission, and Parity selection. The design is fully synthesizable and implemented as a finite state machine.