///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench of the multi-color accumulator
//
`timescale 1ns/1ps

import axi4stream_vip_pkg::*;
import axi4stream_vip_0_pkg::*;
import axi4stream_vip_1_pkg::*;

module tb_multi_color_accumulator();

// Clock parameters
localparam FREQ_HZ = 100000000;
localparam CLK_PERIOD = (1000000000 / FREQ_HZ);
localparam HALF_PERIOD = CLK_PERIOD / 2;

localparam TDATA_WIDTH_IN = 24;
localparam TDATA_WIDTH_OUT = 32;
localparam INDEX_WIDTH = 10;

localparam NUM_COLORS = 4;
localparam COLOR_WIDTH = 8;
localparam COLOR_HEIGHT = 2;
localparam NUM_PIXELS_PER_COLOR = COLOR_WIDTH * COLOR_HEIGHT;
localparam COUNT_WIDTH = $clog2(NUM_PIXELS_PER_COLOR+1);

// Color data format
localparam TDATA_WIDTH = 24;
localparam COLOR_DATA_WIDTH = 8;
localparam R_START_INDEX = 2;
localparam G_START_INDEX = 1;
localparam B_START_INDEX = 0;

// FIFO depth
localparam FIFO_DEPTH = NUM_COLORS;

logic aclk = 1'b0;
logic aresetn = 1'b0;

// AXI input stream signals
logic [TDATA_WIDTH_IN-1:0] tdata_in;
logic [INDEX_WIDTH-1:0] tuser_in;
logic tvalid_in, tlast_in, tready_in;

logic [TDATA_WIDTH_OUT-1:0] tdata_g;
logic [INDEX_WIDTH-1:0] tuser_g;
logic tvalid_g, tlast_g, tready_g;

logic [TDATA_WIDTH_OUT-1:0] tdata_r;
logic [INDEX_WIDTH-1:0] tuser_r;
logic tvalid_r, tlast_r, tready_r;

logic [TDATA_WIDTH_OUT-1:0] tdata_b;
logic [INDEX_WIDTH-1:0] tuser_b;
logic tvalid_b, tlast_b, tready_b;

logic unsigned [COUNT_WIDTH-1:0] max_count;

assign max_count = unsigned'(NUM_PIXELS_PER_COLOR);

// Simulate the clock
always begin
    #HALF_PERIOD aclk = ~aclk;
end

// AXI-S VIPs
axi4stream_vip_0 axis_vip_in (
    .aclk(aclk),
    .aresetn(aresetn),
    .m_axis_tvalid(tvalid_in),
    .m_axis_tready(tready_in),
    .m_axis_tdata(tdata_in),
    .m_axis_tlast(tlast_in),
    .m_axis_tuser(tuser_in)
);

axi4stream_vip_1 axis_vip_g (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axis_tvalid(tvalid_g),
    .s_axis_tready(tready_g),
    .s_axis_tdata(tdata_g),
    .s_axis_tlast(tlast_g)
);

axi4stream_vip_1 axis_vip_r (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axis_tvalid(tvalid_r),
    .s_axis_tready(tready_r),
    .s_axis_tdata(tdata_r),
    .s_axis_tlast(tlast_r)
);

axi4stream_vip_1 axis_vip_b (
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axis_tvalid(tvalid_b),
    .s_axis_tready(tready_b),
    .s_axis_tdata(tdata_b),
    .s_axis_tlast(tlast_b)
);

axi4stream_vip_0_mst_t  axi4stream_vip_0_mst;
axi4stream_vip_1_slv_t  axi4stream_vip_1_slv_g, axi4stream_vip_1_slv_r, axi4stream_vip_1_slv_b;
axi4stream_transaction wr_transaction;
initial begin : START_axi4stream_vip_0_MASTER
    axi4stream_vip_0_mst = new("axi4stream_vip_0_mst", tb_multi_color_accumulator.axis_vip_in.inst.IF);
    axi4stream_vip_0_mst.set_verbosity(400);
    axi4stream_vip_0_mst.start_master();

    axi4stream_vip_1_slv_g = new("axi4stream_vip_1_slv_g", tb_multi_color_accumulator.axis_vip_g.inst.IF);
    axi4stream_vip_1_slv_g.set_verbosity(400);
    axi4stream_vip_1_slv_g.start_slave();

    axi4stream_vip_1_slv_r = new("axi4stream_vip_1_slv_r", tb_multi_color_accumulator.axis_vip_r.inst.IF);
    axi4stream_vip_1_slv_r.set_verbosity(400);
    axi4stream_vip_1_slv_r.start_slave();

    axi4stream_vip_1_slv_b = new("axi4stream_vip_1_slv_b", tb_multi_color_accumulator.axis_vip_b.inst.IF);
    axi4stream_vip_1_slv_b.set_verbosity(400);
    axi4stream_vip_1_slv_b.start_slave();

    #(20 * CLK_PERIOD);
    aresetn = 1'b1;
    #CLK_PERIOD;
    
    wr_transaction = axi4stream_vip_0_mst.driver.create_transaction("Master VIP write transaction");
    wr_transaction.set_xfer_alignment(XIL_AXI4STREAM_XFER_RANDOM);
    for (int k = 0; k < COLOR_HEIGHT; k++) begin
        for (int j = 0; j < NUM_COLORS; j++) begin
            for(int i = 0; i < COLOR_WIDTH; i++) begin
                WR_TRANSACTION_FAIL: assert(wr_transaction.randomize());
                wr_transaction.set_delay(0);
                wr_transaction.set_user_beat(j);
                if(i == COLOR_WIDTH-1 && j == NUM_COLORS-1 && k == COLOR_HEIGHT-1) begin
                    // set tlast to 1
                    wr_transaction.set_last(1);
                end else begin
                    // set tlast to 0
                    wr_transaction.set_last(0);
                end
                axi4stream_vip_0_mst.driver.send(wr_transaction);
            end
        end
    end
end

multi_color_accumulate #(
    .TDATA_WIDTH_IN(TDATA_WIDTH_IN),
    .TDATA_WIDTH_OUT(TDATA_WIDTH_OUT),
    .INDEX_WIDTH(INDEX_WIDTH),

    .MAX_NUM_COLORS(NUM_COLORS),
    .MAX_PIXELS_PER_COLOR(NUM_PIXELS_PER_COLOR),

    .COLOR_WIDTH(COLOR_DATA_WIDTH),
    .G_START_INDEX(G_START_INDEX),
    .R_START_INDEX(R_START_INDEX),
    .B_START_INDEX(B_START_INDEX),

    .FIFO_DEPTH(FIFO_DEPTH)
) DUT (
    // Clock and reset
    .aclk(aclk),
    .aresetn(aresetn),

    // Color in AXI stream
    .tdata_in(tdata_in),
    .tvalid_in(tvalid_in),
    .tlast_in(tlast_in),
    .tuser_in(tuser_in),
    .tready_in(tready_in),

    // Output to AXI-S master
    .tdata_g(tdata_g),
    .tvalid_g(tvalid_g),
    .tlast_g(tlast_g),
    .tuser_g(tuser_g),
    .tready_g(tready_g),

    .tdata_r(tdata_r),
    .tvalid_r(tvalid_r),
    .tlast_r(tlast_r),
    .tuser_r(tuser_r),
    .tready_r(tready_r),

    .tdata_b(tdata_b),
    .tvalid_b(tvalid_b),
    .tlast_b(tlast_b),
    .tuser_b(tuser_b),
    .tready_b(tready_b),

    // Register controls
    .max_count(max_count)
);

endmodule