`ifndef BSG_ROCKET_PKG_VH
`define BSG_ROCKET_PKG_VH

`include "bsg_fsb_pkg.v"

package bsg_nasti_pkg;

  import bsg_fsb_pkg::bsg_fsb_pkt_client_data_t;

  // nasti

  typedef logic  [5:0] bsg_nasti_id_t;
  typedef logic [31:0] bsg_nasti_addr_t;
  typedef logic [63:0] bsg_nasti_data_t;

  typedef struct packed {
    bsg_nasti_addr_t addr;
    logic      [7:0] len;
    logic      [2:0] size;
    logic      [1:0] burst;
    logic            lock;
    logic      [3:0] cache;
    logic      [2:0] prot;
    logic      [3:0] qos;
    logic      [3:0] region;
    bsg_nasti_id_t   id;
  } bsg_nasti_a_pkt; // 67 bits

  typedef struct packed {
    bsg_nasti_data_t data;
    logic            last;
    logic      [7:0] strb;
  } bsg_nasti_w_pkt; // 73 bits

  typedef struct packed {
    logic    [1:0] resp;
    bsg_nasti_id_t id;
  } bsg_nasti_b_pkt; // 8 bits

  typedef struct packed {
    logic      [1:0] resp;
    bsg_nasti_data_t data;
    logic            last;
    bsg_nasti_id_t   id;
  } bsg_nasti_r_pkt; // 73 bits

  typedef struct packed {
    bsg_nasti_addr_t addr;
    bsg_nasti_id_t   id;
    logic            rw;
  } bsg_nasti_sa_pkt; // 39 bits

  typedef struct packed {
    logic            last;
    bsg_nasti_data_t data;
  } bsg_nasti_sw_pkt; // 65 bits

  typedef struct packed {
    logic            last;
    bsg_nasti_data_t data;
    bsg_nasti_id_t   id;
  } bsg_nasti_sr_pkt; // 71 bits

  // tunnel

  parameter bsg_tun_num_in_p = 2;
  parameter bsg_tun_dmx_width_p = $bits(bsg_fsb_pkt_client_data_t) - $clog2(bsg_tun_num_in_p + 1);

  typedef logic [bsg_tun_dmx_width_p - 1:0] bsg_tun_dmx_t;

  typedef logic [bsg_tun_num_in_p - 1:0] bsg_tun_dmx_ctrl_t;
  typedef logic [bsg_tun_num_in_p - 1:0] [bsg_tun_dmx_width_p - 1:0] bsg_tun_dmx_array_t;

  // host

  typedef logic [15:0] bsg_host_t;

endpackage

`endif