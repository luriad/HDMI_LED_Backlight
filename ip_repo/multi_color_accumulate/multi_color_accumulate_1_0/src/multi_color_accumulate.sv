///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Accumulates interleaved color data
//
module multi_color_accumulate #(
    parameter TDATA_WIDTH_IN = 24,
    parameter TDATA_WIDTH_OUT = 32,
    parameter INDEX_WIDTH = 10,

    parameter MAX_NUM_COLORS = 500,
    parameter MAX_PIXELS_PER_COLOR = 1600,
    parameter COUNT_WIDTH = $clog2(MAX_PIXELS_PER_COLOR+1),

    parameter COLOR_WIDTH = 8,
    parameter G_START_INDEX = 16,
    parameter R_START_INDEX = 8,
    parameter B_START_INDEX = 0,

    parameter FIFO_DEPTH = MAX_NUM_COLORS
) (
    // Clock and reset
    input logic aclk,
    input logic aresetn,

    // Color in AXI stream
    input logic [TDATA_WIDTH_IN-1:0] tdata_in,
    input logic tvalid_in,
    input logic tlast_in,
    output logic tready_in,

    // Output to AXI-S master
    output logic [TDATA_WIDTH_OUT-1:0] tdata_g,
    output logic tvalid_g,
    output logic tlast_g,
    input logic tready_g,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_r,
    output logic tvalid_r,
    output logic tlast_r,
    input logic tready_r,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_b,
    output logic tvalid_b,
    output logic tlast_b,
    input logic tready_b,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_divisor,
    output logic tvalid_divisor,
    output logic tlast_divisor,
    input logic tready_divisor,

    // Register controls
    input logic unsigned [COUNT_WIDTH-1:0] max_count
);

logic [TDATA_WIDTH_OUT-1:0] tdata_g_fifo_in;
logic tvalid_g_fifo_in;
logic tlast_g_fifo_in;
logic tready_g_fifo_in;

logic [TDATA_WIDTH_OUT-1:0] tdata_r_fifo_in;
logic tvalid_r_fifo_in;
logic tlast_r_fifo_in;
logic tready_r_fifo_in;

logic [TDATA_WIDTH_OUT-1:0] tdata_b_fifo_in;
logic tvalid_b_fifo_in;
logic tlast_b_fifo_in;
logic tready_b_fifo_in;

logic tvalid_divisor_fifo_in;
logic tlast_divisor_fifo_in;
logic tready_divisor_fifo_in;

logic [TDATA_WIDTH_OUT:0] fifo_data_in_g, fifo_data_in_r, fifo_data_in_b;
logic [TDATA_WIDTH_OUT:0] fifo_data_out_g, fifo_data_out_r, fifo_data_out_b;

logic fifo_data_in_divisor, fifo_data_out_divisor;

assign fifo_data_in_g = {tlast_g_fifo_in, tdata_g_fifo_in};
assign fifo_data_in_r = {tlast_r_fifo_in, tdata_r_fifo_in};
assign fifo_data_in_b = {tlast_b_fifo_in, tdata_b_fifo_in};
assign fifo_data_in_divisor = tlast_divisor_fifo_in;

assign tlast_g = fifo_data_out_g[TDATA_WIDTH_OUT];
assign tdata_g = fifo_data_out_g[TDATA_WIDTH_OUT-1:0];

assign tlast_r = fifo_data_out_r[TDATA_WIDTH_OUT];
assign tdata_r = fifo_data_out_r[TDATA_WIDTH_OUT-1:0];

assign tlast_b = fifo_data_out_b[TDATA_WIDTH_OUT];
assign tdata_b = fifo_data_out_b[TDATA_WIDTH_OUT-1:0];

assign tlast_divisor = fifo_data_out_divisor;

mca_pipeline #(
    .TDATA_WIDTH_IN(TDATA_WIDTH_IN),
    .TDATA_WIDTH_OUT(TDATA_WIDTH_OUT),
    .INDEX_WIDTH(INDEX_WIDTH),

    .MAX_NUM_COLORS(MAX_NUM_COLORS),
    .MAX_PIXELS_PER_COLOR(MAX_PIXELS_PER_COLOR),
    .COUNT_WIDTH(COUNT_WIDTH),

    .COLOR_WIDTH(COLOR_WIDTH),
    .G_START_INDEX(G_START_INDEX),
    .R_START_INDEX(R_START_INDEX),
    .B_START_INDEX(B_START_INDEX)
) pipeline (
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
    .tdata_g(tdata_g_fifo_in),
    .tvalid_g(tvalid_g_fifo_in),
    .tlast_g(tlast_g_fifo_in),
    .tready_g(tready_g_fifo_in),

    .tdata_r(tdata_r_fifo_in),
    .tvalid_r(tvalid_r_fifo_in),
    .tlast_r(tlast_r_fifo_in),
    .tready_r(tready_r_fifo_in),

    .tdata_b(tdata_b_fifo_in),
    .tvalid_b(tvalid_b_fifo_in),
    .tlast_b(tlast_b_fifo_in),
    .tready_b(tready_b_fifo_in),

    .tdata_divisor(tdata_divisor),
    .tvalid_divisor(tvalid_divisor_fifo_in),
    .tlast_divisor(tlast_divisor_fifo_in),
    .tready_divisor(tready_divisor_fifo_in),

    // Register controls
    .max_count(max_count)
);

olo_base_fifo_sync # (
    .Width_g(TDATA_WIDTH_OUT+1),
    .Depth_g(FIFO_DEPTH)
) fifo_g (
    // Control Ports
    .Clk(aclk),
    .Rst(~aresetn),
    // Input Data
    .In_Data(fifo_data_in_g),
    .In_Valid(tvalid_g_fifo_in),
    .In_Ready(tready_g_fifo_in),
    .In_Level(),
    // Output Data
    .Out_Data(fifo_data_out_g),
    .Out_Valid(tvalid_g),
    .Out_Ready(tready_g),
    .Out_Level(),
    // Status
    .Full(),
    .AlmFull(),
    .Empty(),
    .AlmEmpty()
);

olo_base_fifo_sync # (
    .Width_g(TDATA_WIDTH_OUT+1),
    .Depth_g(FIFO_DEPTH)
) fifo_r (
    // Control Ports
    .Clk(aclk),
    .Rst(~aresetn),
    // Input Data
    .In_Data(fifo_data_in_r),
    .In_Valid(tvalid_r_fifo_in),
    .In_Ready(tready_r_fifo_in),
    .In_Level(),
    // Output Data
    .Out_Data(fifo_data_out_r),
    .Out_Valid(tvalid_r),
    .Out_Ready(tready_r),
    .Out_Level(),
    // Status
    .Full(),
    .AlmFull(),
    .Empty(),
    .AlmEmpty()
);

olo_base_fifo_sync # (
    .Width_g(TDATA_WIDTH_OUT+1),
    .Depth_g(FIFO_DEPTH)
) fifo_b (
    // Control Ports
    .Clk(aclk),
    .Rst(~aresetn),
    // Input Data
    .In_Data(fifo_data_in_b),
    .In_Valid(tvalid_b_fifo_in),
    .In_Ready(tready_b_fifo_in),
    .In_Level(),
    // Output Data
    .Out_Data(fifo_data_out_b),
    .Out_Valid(tvalid_b),
    .Out_Ready(tready_b),
    .Out_Level(),
    // Status
    .Full(),
    .AlmFull(),
    .Empty(),
    .AlmEmpty()
);

olo_base_fifo_sync # (
    .Width_g(1),
    .Depth_g(FIFO_DEPTH)
) fifo_divisor (
    // Control Ports
    .Clk(aclk),
    .Rst(~aresetn),
    // Input Data
    .In_Data(fifo_data_in_divisor),
    .In_Valid(tvalid_divisor_fifo_in),
    .In_Ready(tready_divisor_fifo_in),
    .In_Level(),
    // Output Data
    .Out_Data(fifo_data_out_divisor),
    .Out_Valid(tvalid_divisor),
    .Out_Ready(tready_divisor),
    .Out_Level(),
    // Status
    .Full(),
    .AlmFull(),
    .Empty(),
    .AlmEmpty()
);
    
endmodule