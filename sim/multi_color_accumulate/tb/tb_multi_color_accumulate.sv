///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench of the multi-color accumulator
//
`timescale 1ns/1ps

import axi_vip_pkg::*;
import axi4stream_vip_pkg::*;
import tb_mca_bd_axi_vip_0_0_pkg::*;
import tb_mca_bd_axis_vip_in_0_pkg::*;
import tb_mca_bd_axis_vip_g_0_pkg::*;
import tb_mca_bd_axis_vip_r_0_pkg::*;
import tb_mca_bd_axis_vip_b_0_pkg::*;
import tb_mca_bd_axis_vip_div_0_pkg::*;
module tb_multi_color_accumulate();

// Clock parameters
localparam FREQ_HZ = 100000000;
localparam CLK_PERIOD = (1000000000 / FREQ_HZ);
localparam HALF_PERIOD = CLK_PERIOD / 2;

localparam TDATA_WIDTH_IN = 24;
localparam TDATA_WIDTH_OUT = 32;
localparam AXILITE_DATA_WIDTH = 32;

localparam NUM_COLORS = 4;
localparam COLOR_HEIGHT = 2;
localparam COLOR_WIDTH = 8;
localparam NUM_PIXELS_PER_COLOR = COLOR_HEIGHT * COLOR_WIDTH;
localparam AXIS_BASE_ADDRESS = 'h44A0_0000;

logic aclk = 1'b0;
logic datapath_resetn = 1'b0;
logic control_resetn = 1'b0;
logic unsigned [AXILITE_DATA_WIDTH-1:0] num_pixels_per_color = NUM_PIXELS_PER_COLOR;

// Simulate the clock
always begin
    #HALF_PERIOD aclk = ~aclk;
end

// TB BD
tb_mca_bd_wrapper bd (
    .control_resetn(control_resetn),
    .datapath_resetn(datapath_resetn),
    .tb_clk(aclk)
);

tb_mca_bd_axi_vip_0_0_mst_t axi_vip_0_mst;
axi_transaction axilite_wr_transaction;
tb_mca_bd_axis_vip_in_0_mst_t  axi4stream_vip_0_mst;
axi4stream_transaction axi4s_wr_transaction;
logic unsigned [7:0] data_mst [(TDATA_WIDTH_IN/8)-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] g_sum_mst [NUM_COLORS-1:0] = '{default:0};
logic unsigned [TDATA_WIDTH_OUT-1:0] r_sum_mst [NUM_COLORS-1:0] = '{default:0};
logic unsigned [TDATA_WIDTH_OUT-1:0] b_sum_mst [NUM_COLORS-1:0] = '{default:0};
initial begin : axi_masters
    axi_vip_0_mst = new("axilite_vip_0_mst", tb_multi_color_accumulate.bd.tb_mca_bd_i.axi_vip_0.inst.IF);
    axi_vip_0_mst.set_verbosity(400);
    axi_vip_0_mst.start_master();

    axi4stream_vip_0_mst = new("axi4stream_vip_0_mst", tb_multi_color_accumulate.bd.tb_mca_bd_i.axis_vip_in.inst.IF);
    axi4stream_vip_0_mst.set_verbosity(400);
    axi4stream_vip_0_mst.start_master();

    #(20 * CLK_PERIOD);
    control_resetn = 1'b1;
    #CLK_PERIOD;

    axilite_wr_transaction = axi_vip_0_mst.wr_driver.create_transaction("AXI Lite Master VIP write transaction");
    axilite_wr_transaction.set_write_cmd(AXIS_BASE_ADDRESS);
    axilite_wr_transaction.set_data_block(num_pixels_per_color);
    axi_vip_0_mst.wr_driver.send(axilite_wr_transaction);

    #(20 * CLK_PERIOD);
    datapath_resetn = 1'b1;
    #CLK_PERIOD;
    
    axi4s_wr_transaction = axi4stream_vip_0_mst.driver.create_transaction("AXI4Stream Master VIP write transaction");
    axi4s_wr_transaction.set_xfer_alignment(XIL_AXI4STREAM_XFER_RANDOM);
    for (int k = 0; k < COLOR_HEIGHT; k++) begin
        for (int j = 0; j < NUM_COLORS; j++) begin
            for(int i = 0; i < COLOR_WIDTH; i++) begin
                AXIS_WR_TRANSACTION_FAIL: assert(axi4s_wr_transaction.randomize());
                axi4s_wr_transaction.get_data(data_mst);
                g_sum_mst[j] += data_mst[0];
                r_sum_mst[j] += data_mst[1];
                b_sum_mst[j] += data_mst[2];
                axi4s_wr_transaction.set_delay(0);
                axi4s_wr_transaction.set_user_beat(j);
                if(i == COLOR_WIDTH-1 && j == NUM_COLORS-1 && k == COLOR_HEIGHT-1) begin
                    // set tlast to 1
                    axi4s_wr_transaction.set_last(1);
                end else begin
                    // set tlast to 0
                    axi4s_wr_transaction.set_last(0);
                end
                axi4stream_vip_0_mst.driver.send(axi4s_wr_transaction);
            end
        end
    end
end

tb_mca_bd_axis_vip_g_0_slv_t  axi4stream_vip_1_slv_g;
axi4stream_transaction rd_transaction_g;
logic unsigned [7:0] data_slv_g [(TDATA_WIDTH_OUT/8)-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] g_sum_slv [NUM_COLORS-1:0] = '{default:0};
initial begin : AXIS_Slave_g
    axi4stream_vip_1_slv_g = new("axi4stream_vip_1_slv_g", tb_multi_color_accumulate.bd.tb_mca_bd_i.axis_vip_g.inst.IF);
    axi4stream_vip_1_slv_g.set_verbosity(400);
    axi4stream_vip_1_slv_g.start_slave();

    for (int i = 0; i < NUM_COLORS; i++) begin
        axi4stream_vip_1_slv_g.monitor.item_collected_port.get(rd_transaction_g);
        rd_transaction_g.get_data(data_slv_g);
        g_sum_slv[i][31:24] = data_slv_g[0];
        g_sum_slv[i][23:16] = data_slv_g[1];
        g_sum_slv[i][15:8] = data_slv_g[2];
        g_sum_slv[i][7:0] = data_slv_g[3];
    end
    for (int i = 0; i < NUM_COLORS; i++) begin
        $display("============================================");
        $display("Green Sum for Color %0d:\nMaster: %x\nSlave: %x", i, g_sum_mst[i], g_sum_slv[i]);
        if (g_sum_mst[i] == g_sum_slv[i]) begin
            $display("PASS");
        end
        else begin
            $display("FAIL");
            $stop;
        end
        $display("============================================");
    end
end

tb_mca_bd_axis_vip_r_0_slv_t  axi4stream_vip_1_slv_r;
axi4stream_transaction rd_transaction_r;
logic unsigned [7:0] data_slv_r [(TDATA_WIDTH_OUT/8)-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] r_sum_slv [NUM_COLORS-1:0] = '{default:0};
initial begin : AXIS_Slave_r
    axi4stream_vip_1_slv_r = new("axi4stream_vip_1_slv_r", tb_multi_color_accumulate.bd.tb_mca_bd_i.axis_vip_r.inst.IF);
    axi4stream_vip_1_slv_r.set_verbosity(400);
    axi4stream_vip_1_slv_r.start_slave();

    for (int i = 0; i < NUM_COLORS; i++) begin
        axi4stream_vip_1_slv_r.monitor.item_collected_port.get(rd_transaction_r);
        rd_transaction_r.get_data(data_slv_r);
        r_sum_slv[i][31:24] = data_slv_r[0];
        r_sum_slv[i][23:16] = data_slv_r[1];
        r_sum_slv[i][15:8] = data_slv_r[2];
        r_sum_slv[i][7:0] = data_slv_r[3];
    end
    for (int i = 0; i < NUM_COLORS; i++) begin
        $display("============================================");
        $display("Red Sum for Color %0d:\nMaster: %x\nSlave: %x", i, r_sum_mst[i], r_sum_slv[i]);
        if (r_sum_mst[i] == r_sum_slv[i]) begin
            $display("PASS");
        end
        else begin
            $display("FAIL");
            $stop;
        end
        $display("============================================");
    end
end

tb_mca_bd_axis_vip_b_0_slv_t  axi4stream_vip_1_slv_b;
axi4stream_transaction rd_transaction_b;
logic unsigned [7:0] data_slv_b [(TDATA_WIDTH_OUT/8)-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] b_sum_slv [NUM_COLORS-1:0] = '{default:0};
initial begin : AXIS_Slave_b
    axi4stream_vip_1_slv_b = new("axi4stream_vip_1_slv_b", tb_multi_color_accumulate.bd.tb_mca_bd_i.axis_vip_b.inst.IF);
    axi4stream_vip_1_slv_b.set_verbosity(400);
    axi4stream_vip_1_slv_b.start_slave();

    for (int i = 0; i < NUM_COLORS; i++) begin
        axi4stream_vip_1_slv_b.monitor.item_collected_port.get(rd_transaction_b);
        rd_transaction_b.get_data(data_slv_b);
        b_sum_slv[i][31:24] = data_slv_b[0];
        b_sum_slv[i][23:16] = data_slv_b[1];
        b_sum_slv[i][15:8] = data_slv_b[2];
        b_sum_slv[i][7:0] = data_slv_b[3];
    end
    for (int i = 0; i < NUM_COLORS; i++) begin
        $display("============================================");
        $display("Blue Sum for Color %0d:\nMaster: %x\nSlave: %x", i, b_sum_mst[i], b_sum_slv[i]);
        if (b_sum_mst[i] == b_sum_slv[i]) begin
            $display("PASS");
        end
        else begin
            $display("FAIL");
            $stop;
        end
        $display("============================================");
    end
end

endmodule