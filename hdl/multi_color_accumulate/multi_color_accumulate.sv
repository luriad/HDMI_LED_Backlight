///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Accumulates interleaved color data
//
module multi_color_accumulate #(
    parameter TDATA_WIDTH_IN = 24,
    parameter TDATA_WIDTH_OUT = 32,
    parameter DIV_WIDTH_OUT = 16,
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
    input logic [INDEX_WIDTH-1:0] tuser_in,
    input logic tlast_in,
    output logic tready_in,

    // Output to AXI-S master
    output logic [TDATA_WIDTH_OUT-1:0] tdata_g,
    output logic tvalid_g,
    output logic tlast_g,

    output logic [DIV_WIDTH_OUT-1:0] tdata_divisor_g,
    output logic tvalid_divisor_g,
    output logic tlast_divisor_g,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_r,
    output logic tvalid_r,
    output logic tlast_r,

    output logic [DIV_WIDTH_OUT-1:0] tdata_divisor_r,
    output logic tvalid_divisor_r,
    output logic tlast_divisor_r,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_b,
    output logic tvalid_b,
    output logic tlast_b,

    output logic [DIV_WIDTH_OUT-1:0] tdata_divisor_b,
    output logic tvalid_divisor_b,
    output logic tlast_divisor_b,

    // Register controls
    input logic unsigned [COUNT_WIDTH-1:0] max_count
);

logic [DIV_WIDTH_OUT-1:0] tdata_divisor;
logic tvalid_divisor;
logic tlast_divisor;

assign tdata_divisor_g = tdata_divisor;
assign tdata_divisor_r = tdata_divisor;
assign tdata_divisor_b = tdata_divisor;

assign tvalid_divisor_g = tvalid_divisor;
assign tvalid_divisor_r = tvalid_divisor;
assign tvalid_divisor_b = tvalid_divisor;

assign tlast_divisor_g = tlast_divisor;
assign tlast_divisor_r = tlast_divisor;
assign tlast_divisor_b = tlast_divisor;

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
    .tdata_g(tdata_g),
    .tvalid_g(tvalid_g),
    .tlast_g(tlast_g),

    .tdata_r(tdata_r),
    .tvalid_r(tvalid_r),
    .tlast_r(tlast_r),

    .tdata_b(tdata_b),
    .tvalid_b(tvalid_b),
    .tlast_b(tlast_b),

    .tdata_divisor(tdata_divisor),
    .tvalid_divisor(tvalid_divisor),
    .tlast_divisor(tlast_divisor),

    // Register controls
    .max_count(max_count)
);
    
endmodule