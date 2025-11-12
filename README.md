# Packet Router Verilog Project

## Overview
This project implements a packet router system in Verilog that routes incoming data packets to one of three FIFO buffers based on the packet address. It handles packet buffering, flow control, and error detection through parity checks.

## Modules

### router_fifo.v
A FIFO buffer module that temporarily stores packet data before processing. It manages write/read operations with full/empty flags and supports soft reset.

### router_sync.v
Synchronizes incoming packet addresses to appropriate FIFOs, controls write enables and soft resets stalled FIFOs.

### router_fsm.v
Finite State Machine controlling the router workflow: address decoding, data loading, parity checking, and FIFO management.

### router_reg.v
Stores packet headers and parity bits, performs internal parity calculations, and detects parity errors.

### router_top.v
Top-level module integrating all submodules into the complete router system.

## Features
- Packet buffering with FIFO management.
- Address decoding and routing to multiple FIFOs.
- Parity-based error detection.
- Soft reset to clear stalled FIFOs.
- Modular design for easy expansion.

## Usage
- Connect the input clock, reset, packet data, and control signals to `router_top`.
- Monitor FIFO outputs and error signals to track router status.
- Adjust parameters or add features as needed for specific applications.

## License
This project is open source. Feel free to use and modify for educational or development purposes.

## Author
[AMBIKESH SINGH]




