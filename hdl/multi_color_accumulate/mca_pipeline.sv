///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Data pipeline for multi-color accumulator
//
module mca_pipeline #(
    parameter TDATA_WIDTH_IN = 24,
    parameter TDATA_WIDTH_OUT = 32,
    parameter INDEX_WIDTH = 10,

    parameter MAX_NUM_COLORS = 500,
    parameter MAX_PIXELS_PER_COLOR = 1600,
    parameter COUNT_WIDTH = $clog2(MAX_PIXELS_PER_COLOR+1),

    parameter COLOR_WIDTH = 8,
    parameter G_START_INDEX = 16,
    parameter R_START_INDEX = 8,
    parameter B_START_INDEX = 0
) (
    // Clock and reset
    input logic aclk,
    input logic aresetn,

    // Color in AXI stream
    input logic [TDATA_WIDTH_IN-1:0] tdata_in,
    input logic tvalid_in,
    input logic tlast_in,
    input logic [INDEX_WIDTH-1:0] tuser_in,
    output logic tready_in,

    // Output to AXI-S master
    output logic [TDATA_WIDTH_OUT-1:0] tdata_g,
    output logic tvalid_g,
    output logic tlast_g,
    output logic [INDEX_WIDTH-1:0] tuser_g,
    input logic tready_g,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_r,
    output logic tvalid_r,
    output logic tlast_r,
    output logic [INDEX_WIDTH-1:0] tuser_r,
    input logic tready_r,

    output logic [TDATA_WIDTH_OUT-1:0] tdata_b,
    output logic tvalid_b,
    output logic tlast_b,
    output logic [INDEX_WIDTH-1:0] tuser_b,
    input logic tready_b,

    // Register controls
    input logic unsigned [COUNT_WIDTH-1:0] max_count
);

localparam COUNT_RAM_WIDTH = $clog2(MAX_PIXELS_PER_COLOR); // count ram does not need to include last pixel, see if we can save a bit

// RAMs
logic unsigned [TDATA_WIDTH_OUT-1:0] g_sums [MAX_NUM_COLORS-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] r_sums [MAX_NUM_COLORS-1:0];
logic unsigned [TDATA_WIDTH_OUT-1:0] b_sums [MAX_NUM_COLORS-1:0];
logic unsigned [COUNT_RAM_WIDTH-1:0] all_color_counts [MAX_NUM_COLORS-1:0];

// RAM init
typedef enum logic {INIT, IDLE} ram_init_states;
ram_init_states sm_vec;
logic unsigned [INDEX_WIDTH-1:0] init_index;
logic init_done;

// Pipeline inputs
logic unsigned [COLOR_WIDTH-1:0] g_0, g_1;
logic unsigned [COLOR_WIDTH-1:0] r_0, r_1;
logic unsigned [COLOR_WIDTH-1:0] b_0, b_1;
logic unsigned [INDEX_WIDTH-1:0] index_0, index_1, index_2, index_3, index_4;
logic valid_0, valid_1, valid_2, valid_3;
logic valid_4_g, valid_4_r, valid_4_b;
logic last_0, last_1, last_2, last_3, last_4;

// Pipeline outputs
logic unsigned [TDATA_WIDTH_OUT-1:0] g_sum_1, g_sum_2, g_sum_3, g_sum_4;
logic unsigned [TDATA_WIDTH_OUT-1:0] r_sum_1, r_sum_2, r_sum_3, r_sum_4;
logic unsigned [TDATA_WIDTH_OUT-1:0] b_sum_1, b_sum_2, b_sum_3, b_sum_4;
logic unsigned [COUNT_WIDTH-1:0] count_1, count_2;

// Combinational logic
logic unsigned [TDATA_WIDTH_OUT-1:0] g_add, r_add, b_add;
logic unsigned [COUNT_WIDTH-1:0] count_incr;

// Assign AXI-S slave side
assign tready_in = init_done;
assign valid_0 = tvalid_in & init_done;
assign last_0 = tlast_in;

assign g_0 = tdata_in[G_START_INDEX+COLOR_WIDTH-1:G_START_INDEX];
assign r_0 = tdata_in[R_START_INDEX+COLOR_WIDTH-1:R_START_INDEX];
assign b_0 = tdata_in[B_START_INDEX+COLOR_WIDTH-1:B_START_INDEX];
assign index_0 = tuser_in;

// Assign AXI-S master side
assign tdata_g = g_sum_4;
assign tvalid_g = valid_4_g;
assign tlast_g = last_4;
assign tuser_g = index_4;

assign tdata_r = r_sum_4;
assign tvalid_r = valid_4_r;
assign tlast_r = last_4;
assign tuser_r = index_4;

assign tdata_b = b_sum_4;
assign tvalid_b = valid_4_b;
assign tlast_b = last_4;
assign tuser_b = index_4;

// Assign internal
assign g_add = g_sum_1 + g_1;
assign r_add = r_sum_1 + r_1;
assign b_add = b_sum_1 + b_1;
assign count_incr = count_1 + 1;

// Pipeline stage 1:s Read old sum
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        g_1 <= 'b0;
        r_1 <= 'b0;
        b_1 <= 'b0;
        index_1 <= MAX_NUM_COLORS;

        g_sum_1 <= 'b0;
        r_sum_1 <= 'b0;
        b_sum_1 <= 'b0;
        count_1 <= 'b0;

        valid_1 <= 'b0;
        last_1 <= 'b0;
    end
    else begin
        g_1 <= g_0;
        r_1 <= r_0;
        b_1 <= b_0;
        index_1 <= index_0;
        valid_1 <= valid_0;
        last_1 <= last_0;
        if (valid_1 == 1'b1 && index_0 == index_1) begin
            g_sum_1 <= g_add;
            r_sum_1 <= r_add;
            b_sum_1 <= b_add;
            count_1 <= count_incr;
        end 
        else if (valid_2 == 1'b1 && index_0 == index_2) begin
            g_sum_1 <= g_sum_2;
            r_sum_1 <= r_sum_2;
            b_sum_1 <= b_sum_2;
            count_1 <= count_2;
        end 
        else begin
            g_sum_1 <= g_sums[index_0];
            r_sum_1 <= r_sums[index_0];
            b_sum_1 <= b_sums[index_0];
            count_1 <= all_color_counts[index_0];
        end
    end
end

// Pipeline stage 2: Add
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        index_2 <= MAX_NUM_COLORS;

        g_sum_2 <= 'b0;
        r_sum_2 <= 'b0;
        b_sum_2 <= 'b0;
        count_2 <= 'b0;

        valid_2 <= 'b0;
        last_2 <= 'b0;
    end
    else begin
        index_2 <= index_1;

        g_sum_2 <= g_add;
        r_sum_2 <= r_add;
        b_sum_2 <= b_add;
        count_2 <= count_incr;

        valid_2 <= valid_1;
        last_2 <= last_1;
    end
end

// Pipeline stage 3: Write new sum
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        index_3 <= MAX_NUM_COLORS;
        g_sum_3 <= 'b0;
        r_sum_3 <= 'b0;
        b_sum_3 <= 'b0;
        valid_3 <= 'b0;
        last_3 <= 'b0;
    end
    else begin
        index_3 <= index_2;
        g_sum_3 <= g_sum_2;
        r_sum_3 <= r_sum_2;
        b_sum_3 <= b_sum_2;
        valid_3 <= valid_2 == 1'b1 && ((count_2 == max_count) || (last_2 == 1'b1));
        last_3 <= last_2;
    end
end

// RAM init state machine transitions
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        sm_vec <= INIT; 
    end
    else begin
        case (sm_vec)
            INIT: 
                if (init_index == MAX_NUM_COLORS-1) begin
                    sm_vec <= IDLE;
                end
                else begin
                    sm_vec <= INIT;
                end
            IDLE:
                sm_vec <= IDLE;
            default: 
                sm_vec <= INIT;
        endcase
    end
end

// RAM init state machine outputs
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        init_done <= 1'b0;
        init_index <= 0;
    end
    else begin
        case (sm_vec)
            INIT: 
                begin
                    init_index <= init_index + 1;
                    init_done <= init_index == MAX_NUM_COLORS-1;
                end
            IDLE:
                init_done <= 1'b1;
        endcase
    end
end

// Stage 3 RAM
always @(posedge aclk) begin
    if (init_done == 1'b0) begin
        g_sums[init_index] <= 0;
        r_sums[init_index] <= 0;
        b_sums[init_index] <= 0;
        all_color_counts[init_index] <= 0;
    end
    else if (valid_2 == 1'b1) begin
        if (count_2 == max_count) begin
            g_sums[index_2] <= 0;
            r_sums[index_2] <= 0;
            b_sums[index_2] <= 0;
            all_color_counts[index_2] <= 0;
        end 
        else begin
            g_sums[index_2] <= g_sum_2;
            r_sums[index_2] <= r_sum_2;
            b_sums[index_2] <= b_sum_2;
            all_color_counts[index_2] <= count_2;
        end
    end
end

// Pipeline stage 4: AXI out final sum
always @(posedge aclk) begin
    if (aresetn == 1'b0) begin
        index_4 <= MAX_NUM_COLORS;
        g_sum_4 <= 'b0;
        valid_4_g <= 'b0;
        r_sum_4 <= 'b0;
        valid_4_r <= 'b0;
        b_sum_4 <= 'b0;
        valid_4_b <= 'b0;
        last_4 <= 'b0;
    end
    else begin
        if (valid_3 == 1'b1) begin
            index_4 <= index_3;
            g_sum_4 <= g_sum_3;
            valid_4_g <= 1'b1;
            r_sum_4 <= r_sum_3;
            valid_4_r <= 1'b1;
            b_sum_4 <= b_sum_3;
            valid_4_b <= 1'b1;
            last_4 <= last_3;
        end
        else begin
            if (valid_4_g == 1'b1 && tready_g == 1'b1) begin
                valid_4_g <= 1'b0;
            end
            if (valid_4_r == 1'b1 && tready_r == 1'b1) begin
                valid_4_r <= 1'b0;
            end
            if (valid_4_b == 1'b1 && tready_b == 1'b1) begin
                valid_4_b <= 1'b0;
            end
        end
    end
end
    
endmodule