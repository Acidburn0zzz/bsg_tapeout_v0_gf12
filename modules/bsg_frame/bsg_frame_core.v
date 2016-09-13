`include "bsg_comm_link.vh"

module bsg_frame_core #(
                        parameter gateway_p=0
                        ,parameter nodes_p=1

			// generally will not be changing these parameters
			,parameter num_channels_p=4
                        ,parameter channel_width_p=8
                        ,parameter uniqueness_p=0

                        ,parameter bsg_comm_link_i_s_width_lp = `bsg_comm_link_channel_in_s_width(channel_width_p)
                        ,parameter bsg_comm_link_o_s_width_lp = `bsg_comm_link_channel_out_s_width(channel_width_p)
                        )
   (
    input core_clk_i
    , input async_reset_i
    , input io_master_clk_i

    // I/O
    , input  [num_channels_p-1:0][bsg_comm_link_i_s_width_lp-1:0] bsg_comm_link_i
    , output [num_channels_p-1:0][bsg_comm_link_o_s_width_lp-1:0] bsg_comm_link_o

    // generated by gateway (FPGA) and sent to slave (ASIC); unused by slave
    , output reg im_slave_reset_tline_r_o

    // post-calibration reset signal synchronous to the core clock
    , output core_calib_reset_r_o
    );

   localparam ring_bytes_lp    = 10;
   localparam ring_width_lp = ring_bytes_lp*channel_width_p;

   `declare_fsb_in_s (ring_width_lp);
   `declare_fsb_out_s(ring_width_lp);

   bsg_fsb_in_s  [nodes_p-1:0] fsb_li;
   bsg_fsb_out_s [nodes_p-1:0] fsb_lo;

   if (gateway_p)
     begin: m
        bsg_frame_gateway
          #(.ring_width_p(ring_width_lp)
            ,.nodes_p    (nodes_p)
            ) bfan
            (.clk_i(core_clk_i)
             ,.fsb_i(fsb_li)
             ,.fsb_o(fsb_lo)
             );
     end
   else
     begin: s
        bsg_frame_asic
          #(.ring_width_p(ring_width_lp)
            ,.nodes_p    (nodes_p)
            ) bfan
            (.clk_i(core_clk_i)
             ,.fsb_i(fsb_li)
             ,.fsb_o(fsb_lo)
             );
     end

   bsg_frame_io #(.ring_width_p(ring_width_lp)
                  ,.nodes_p    (nodes_p      )
                  ,.gateway_p  (gateway_p    )
                  )
     (.core_clk_i      (core_clk_i     )
      ,.async_reset_i  (async_reset_i  )
      ,.io_master_clk_i(io_master_clk_i)

      ,.fsb_i(fsb_lo)
      ,.fsb_o(fsb_li)

      ,.bsg_comm_link_i
      ,.bsg_comm_link_o

      ,.im_slave_reset_tline_r_o
      ,.core_reset_o
      );

endmodule
