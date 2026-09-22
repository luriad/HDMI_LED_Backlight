///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Adder half of the multi-color averager
//
`timescale 1 ns / 1 ps

module multi_color_accumulate_axi_top #
(
	// Users to add parameters here

	// User parameters ends
	parameter integer C_AXIS_TUSER_WIDTH = 10;
	parameter integer C_MAX_NUM_COLORS = 250;
	parameter integer C_MAX_PIXELS_PER_COLOR = 2000;
	parameter integer C_COLOR_DATA_WIDTH = 8;
	parameter integer C_G_START_INDEX = 16;
	parameter integer C_R_START_INDEX = 8;
	parameter integer C_B_START_INDEX = 0;
	parameter integer C_FIFO_DEPTH = C_MAX_NUM_COLORS;
	// Do not modify the parameters beyond this line


	// Parameters of Axi Slave Bus Interface S00_AXI
	parameter integer C_S00_AXI_DATA_WIDTH	= 32,
	parameter integer C_S00_AXI_ADDR_WIDTH	= 4,

	// Parameters of Axi Slave Bus Interface S_AXIS_IN
	parameter integer C_S_AXIS_IN_TDATA_WIDTH	= 24,

	// Parameters of Axi Master Bus Interface M_AXIS
	parameter integer C_M_AXIS_TDATA_WIDTH	= 32
)
(
	// Users to add ports here

	// User ports ends
	// Do not modify the ports beyond this line


	// Ports of Axi Slave Bus Interface S00_AXI
	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready,

	// AXI Stream Clock and reset
	input wire  axis_aclk,
	input wire  axis_aresetn,

	// Ports of Axi Slave Bus Interface S_AXIS_IN
	output wire  s_axis_in_tready,
	input wire [C_S_AXIS_IN_TDATA_WIDTH-1 : 0] s_axis_in_tdata,
	input wire [C_AXIS_TUSER_WIDTH-1 : 0] s_axis_in_tuser,
	input wire  s_axis_in_tlast,
	input wire  s_axis_in_tvalid,

	// Ports of Axi Master Bus Interface M_AXIS_G
	output wire  m_axis_g_tvalid,
	output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_g_tdata,
	output wire  m_axis_g_tlast,
	input wire  m_axis_g_tready,

	// Ports of Axi Master Bus Interface M_AXIS_R
	output wire  m_axis_r_tvalid,
	output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_r_tdata,
	output wire  m_axis_r_tlast,
	input wire  m_axis_r_tready,

	// Ports of Axi Master Bus Interface M_AXIS_B
	output wire  m_axis_b_tvalid,
	output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_b_tdata,
	output wire  m_axis_b_tlast,
	input wire  m_axis_b_tready,

	// Ports of Axi Master Bus Interface M_AXIS_DIVISOR
	output wire  m_axis_divisor_tvalid,
	output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] m_axis_divisor_tdata,
	output wire  m_axis_divisor_tlast,
	input wire  m_axis_divisor_tready
);

wire num_pixels_per_color;

// Instantiation of Axi Bus Interface S00_AXI
multi_color_accumulate_slave_lite_v1_0_S00_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
) multi_color_accumulate_slave_lite_v1_0_S00_AXI_inst (
	.NUM_PIXELS_PER_COLOR(num_pixels_per_color),
	.S_AXI_ACLK(s00_axi_aclk),
	.S_AXI_ARESETN(s00_axi_aresetn),
	.S_AXI_AWADDR(s00_axi_awaddr),
	.S_AXI_AWPROT(s00_axi_awprot),
	.S_AXI_AWVALID(s00_axi_awvalid),
	.S_AXI_AWREADY(s00_axi_awready),
	.S_AXI_WDATA(s00_axi_wdata),
	.S_AXI_WSTRB(s00_axi_wstrb),
	.S_AXI_WVALID(s00_axi_wvalid),
	.S_AXI_WREADY(s00_axi_wready),
	.S_AXI_BRESP(s00_axi_bresp),
	.S_AXI_BVALID(s00_axi_bvalid),
	.S_AXI_BREADY(s00_axi_bready),
	.S_AXI_ARADDR(s00_axi_araddr),
	.S_AXI_ARPROT(s00_axi_arprot),
	.S_AXI_ARVALID(s00_axi_arvalid),
	.S_AXI_ARREADY(s00_axi_arready),
	.S_AXI_RDATA(s00_axi_rdata),
	.S_AXI_RRESP(s00_axi_rresp),
	.S_AXI_RVALID(s00_axi_rvalid),
	.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here
multi_color_accumulate #(
    .TDATA_WIDTH_IN(C_S_AXIS_IN_TDATA_WIDTH),
    .TDATA_WIDTH_OUT(C_M_AXIS_TDATA_WIDTH),
    .INDEX_WIDTH(C_AXIS_TUSER_WIDTH),

    .MAX_NUM_COLORS(C_MAX_NUM_COLORS),
    .MAX_PIXELS_PER_COLOR(C_MAX_PIXELS_PER_COLOR),

    .COLOR_WIDTH(COLOR_DATA_WIDTH),
    .G_START_INDEX(G_START_INDEX),
    .R_START_INDEX(R_START_INDEX),
    .B_START_INDEX(B_START_INDEX),

    .FIFO_DEPTH(FIFO_DEPTH)
) multi_color_accumulate_inst (
    // Clock and reset
    .aclk(axis_aclk),
    .aresetn(axis_aresetn),

    // Color in AXI stream
    .tdata_in(s_axis_in_tdata),
    .tvalid_in(s_axis_in_tvalid),
    .tlast_in(s_axis_in_tlast),
    .tuser_in(s_axis_in_tuser),
    .tready_in(s_axis_in_tready),

    // Output to AXI-S master
    .tdata_g(m_axis_g_tdata),
    .tvalid_g(m_axis_g_tvalid),
    .tlast_g(m_axis_g_tlast),
    .tready_g(m_axis_g_tready),

    .tdata_r(m_axis_r_tdata),
    .tvalid_r(m_axis_r_tvalid),
    .tlast_r(m_axis_r_tlast),
    .tready_r(m_axis_r_tready),

    .tdata_b(m_axis_b_tdata),
    .tvalid_b(m_axis_b_tvalid),
    .tlast_b(m_axis_b_tlast),
    .tready_b(m_axis_b_tready),

	.tdata_divisor(m_axis_divisor_tdata),
    .tvalid_divisor(m_axis_divisor_tvalid),
    .tlast_divisor(m_axis_divisor_tlast),
    .tready_divisor(m_axis_divisor_tready),

    // Register controls
    .max_count(num_pixels_per_color)
);
	// User logic ends

endmodule
