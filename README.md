🧭 1x3 Router (Verilog HDL)
📘 Overview

The 1x3 Router is a digital data routing system designed in Verilog HDL that routes incoming packets from a single input port to one of three output ports based on the packet’s destination address.
It is implemented using modular design principles and includes FIFO buffers, control FSM, synchronization logic, and error-checking mechanisms to ensure reliable packet transfer.

This project demonstrates the design of a simple packet router with flow control, synchronization, and error detection, suitable for use in SoC communication subsystems or network-on-chip (NoC) architectures.

⚙️ Functional Description

The router accepts an 8-bit data stream with a control flag (total 9 bits per entry) and distributes packets to one of three output FIFOs (FIFO0, FIFO1, FIFO2) based on the header information.
It ensures proper data flow, handles FIFO full/empty conditions, and validates packets using parity checking for error detection.

🧩 Module Descriptions
1. router_fifo.v

Purpose:
Implements a First-In-First-Out (FIFO) memory buffer for temporary data storage.
Each of the three output channels uses a dedicated FIFO to store routed packet data before further processing.

Key Features:

Separate read and write pointers for asynchronous access.

Memory array with 16 entries × 9 bits (8 data bits + 1 control bit).

Full and empty status flags for flow control.

Soft reset capability to clear the buffer.

Counter logic to track the number of stored bytes.

Why It’s Used:
The FIFO smooths the flow of data between asynchronous modules, handles input data bursts, and prevents packet loss by buffering packets during high load conditions.

2. router_sync.v

Purpose:
Manages synchronization between the router’s input data stream and the three FIFOs.
It detects destination addresses, generates appropriate write enable signals, and handles FIFO stall recovery.

Key Features:

Detects the destination address and routes data to the correct FIFO.

Generates write enable signals for the selected FIFO.

Monitors full and empty status of FIFOs.

Generates soft reset pulses if FIFOs remain idle or stuck.

Produces valid output signals when data is available in FIFOs.

Why It’s Used:
Ensures that packets are written to the correct FIFO and prevents data overflow or underflow, maintaining synchronization between data input and output.

3. router_fsm.v

Purpose:
Implements the Finite State Machine (FSM) that governs the overall router operation.
It controls data loading, address decoding, parity checking, and error handling.

Key Features:

Defined states such as:

DECODE_ADDRESS

LOAD_FIRST_DATA

LOAD_DATA

FIFO_FULL_STATE

LOAD_PARITY

CHECK_PARITY_ERROR

State transitions based on:

Packet validity

FIFO status (full/empty)

Parity check results

Generates control signals for:

Data load enable

FIFO write enable

Error detection and recovery

Why It’s Used:
Acts as the brain of the router, orchestrating all modules and ensuring robust packet flow and error management through well-defined control logic.

4. router_reg.v

Purpose:
Provides register storage for packet headers and parity bits, and performs parity generation and checking for data integrity verification.

Key Features:

Registers for:

Packet header

Internal parity

External parity

Logic for parity calculation and comparison.

Outputs an error signal if a parity mismatch is detected.

Why It’s Used:
Ensures data integrity by verifying that transmitted packets are not corrupted during routing.

5. router_top.v

Purpose:
Acts as the top-level integration module, connecting all submodules — FSM, Synchronizer, FIFOs, and Register — into a single functional unit.

Key Features:

Instantiates and interconnects:

3 × router_fifo

router_sync

router_fsm

router_reg

Connects internal control and status signals between modules.

Provides a unified interface for:

Data input

Clock and reset signals

Output ports

Error and status flags

Why It’s Used:
Serves as the complete system module, integrating control, data flow, synchronization, and error checking to realize the functionality of the 1x3 router.

🧠 System Operation Summary

Input Stage:

Incoming packets are received serially at the input port.

The first byte contains the destination address (header).

Address Decode and Routing:

The FSM decodes the address and enables the corresponding FIFO via router_sync.

Data Loading:

Packet data bytes are sequentially written into the selected FIFO.

Parity Check:

The final byte (parity bit) is compared against internally generated parity in router_reg.

Any mismatch triggers a parity error flag.

Data Output:

Each FIFO outputs data asynchronously to its respective output port when read-enabled.

🧾 Design Specifications
Parameter	Description
Input width	8-bit data + 1 control flag
FIFO depth	16 entries
No. of output ports	3
Error detection	Parity-based
Control mechanism	FSM-based
Reset type	Active-high (soft reset supported)
Flow control	Full/empty flags and soft reset
🧰 Applications

Network-on-Chip (NoC) routers

SoC interconnect systems

Embedded communication subsystems

High-speed packet routing and buffering applications

🧑‍💻 Author

Ambikesh Singh
Designed and implemented using Verilog HDL for FPGA/ASIC simulation and synthesis.
