
`include "router_fifo.v"
`include "router_fsm.v"
`include "router_reg.v"
`include "router_sync.v"

module router_top(
    input        clock,
    input        resetn,
    input        pkt_valid,
    input        read_enb_0,
    input        read_enb_1,
    input        read_enb_2,
    input  [7:0] data_in,

    output [7:0] data_out_0,
    output [7:0] data_out_1,
    output [7:0] data_out_2,
    output       vld_out_0,
    output       vld_out_1,
    output       vld_out_2,
    output       err,
    output       busy
);

    // Internal wires
    wire soft_reset_0, full_0, empty_0;
    wire soft_reset_1, full_1, empty_1;
    wire soft_reset_2, full_2, empty_2;

    wire fifo_full;
    wire detect_add;
    wire ld_state;
    wire laf_state;
    wire full_state;
    wire lfd_state;
    wire rst_int_reg;
    wire parity_done;
    wire low_packet_valid;
    wire write_enb_reg;

    wire [2:0] write_enb;
    wire [7:0] d_in;          // data from register to selected FIFO (dout)

    // ------------------ FIFO Instantiations ------------------
    router_fifo FIFO_0 (
        .clock(clock),
        .resetn(resetn),
        .soft_reset(soft_reset_0),
        .write_enb(write_enb[0]),
        .read_enb(read_enb_0),
        .lfd_state(lfd_state),
        .data_in(d_in),
        .full(full_0),
        .empty(empty_0),
        .data_out(data_out_0)
    );

    router_fifo FIFO_1 (
        .clock(clock),
        .resetn(resetn),
        .soft_reset(soft_reset_1),
        .write_enb(write_enb[1]),
        .read_enb(read_enb_1),
        .lfd_state(lfd_state),
        .data_in(d_in),
        .full(full_1),
        .empty(empty_1),
        .data_out(data_out_1)
    );

    router_fifo FIFO_2 (
        .clock(clock),
        .resetn(resetn),
        .soft_reset(soft_reset_2),
        .write_enb(write_enb[2]),
        .read_enb(read_enb_2),
        .lfd_state(lfd_state),
        .data_in(d_in),
        .full(full_2),
        .empty(empty_2),
        .data_out(data_out_2)
    );

    // ------------------ Register Instantiation ------------------
    router_reg REGISTER (
        .clock(clock),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .data_in(data_in),
        .fifo_full(fifo_full),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .lfd_state(lfd_state),
        .rst_int_reg(rst_int_reg),
        .err(err),
        .parity_done(parity_done),
        .low_packet_valid(low_packet_valid),
        .dout(d_in)
    );

    // ------------------ Synchronizer Instantiation ------------------
    router_sync SYNCHRONIZER (
        .clock(clock),
        .resetn(resetn),
        .data_in(data_in[1:0]),
        .detect_add(detect_add),
        .full_0(full_0),
        .full_1(full_1),
        .full_2(full_2),
        .empty_0(empty_0),
        .empty_1(empty_1),
        .empty_2(empty_2),
        .write_enb_reg(write_enb_reg),
        .read_enb_0(read_enb_0),
        .read_enb_1(read_enb_1),
        .read_enb_2(read_enb_2),
        .write_enb(write_enb),
        .fifo_full(fifo_full),
        .vld_out_0(vld_out_0),
        .vld_out_1(vld_out_1),
        .vld_out_2(vld_out_2),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2)
    );

    // ------------------ FSM Instantiation ------------------
    router_fsm FSM (
        .clock(clock),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .data_in(data_in[1:0]),
        .fifo_full(fifo_full),
        .fifo_empty_0(empty_0),
        .fifo_empty_1(empty_1),
        .fifo_empty_2(empty_2),
        .soft_reset_0(soft_reset_0),
        .soft_reset_1(soft_reset_1),
        .soft_reset_2(soft_reset_2),
        .parity_done(parity_done),
        .low_packet_valid(low_packet_valid),
        .write_enb_reg(write_enb_reg),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .lfd_state(lfd_state),
        .full_state(full_state),
        .rst_int_reg(rst_int_reg),
        .busy(busy)
    );

endmodule
