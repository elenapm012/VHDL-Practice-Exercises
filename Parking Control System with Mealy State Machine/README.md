# Parking Occupancy Controller Using a Mealy FSM in VHDL

Design and implementation of a fully synthesizable parking occupancy controller in VHDL using a Mealy finite state machine.

The system monitors vehicle movement using two photo-sensors placed at the parking entrance/exit. Each sensor outputs a logic high ('1') when its beam is blocked. By analyzing the sequence of sensor activations, the controller distinguishes between vehicle entry, vehicle exit, and pedestrian crossings.

The design tracks the number of vehicles currently parked in the garage, assuming a single shared entrance and exit. A Mealy FSM with an asynchronous reset is used to detect valid entry and exit sequences and update the vehicle count accordingly.

The exercise also includes the definition and representation of the FSM state transition diagram, highlighting correct detection of parking occupancy events.