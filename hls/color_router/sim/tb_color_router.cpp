///////////////////////////////////////////////////////////////////////////////////////////////////
// Description
///////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench for the color router simulation
//
#include "../src/color_router.hpp"

void tb_color_router_output(hls::stream<color_coord_axis>& axis_out, std::string name) {  
    static int i = 0;      
    bool last = false;
    printf("==> Group %s\n", name.c_str());
    while(!last) {
        while (axis_out.empty());
        color_coord_axis pkt_out = axis_out.read();
        color c = pkt_out.data;
        xy_coordinates coord;
        coord.x = USER_TO_COORD_X(pkt_out.user);
        coord.y = USER_TO_COORD_Y(pkt_out.user);
        last = pkt_out.last;
        printf("Packet %d: Color = %d, X = %d, Y= %d, last = %d\n", i++, c.to_int(), coord.x.to_int(), coord.y.to_int(), last);
    }
}

void tb_color_router_driver(int num_frames, reg_settings& settings) {
    hls::stream<wide_color_axis> axis_in, axis_passthrough;
    axis_streams_dir axis_out;
    bool last = false;
    static int i = 0;

    for (int f = 0; f < num_frames; f++) {
        bool last = false;
        printf("======Frame %d======\n", f);
        for (int y = 0; y < settings.resolution.y; y++) {
            for (int x = 0; x < settings.resolution.x; x++) {
                wide_color_axis pkt_in;
                pkt_in.data = x+y;
                pkt_in.last = x == settings.resolution.x-1 && y == settings.resolution.y-1;
                axis_in.write(pkt_in);
                color_router(axis_in, axis_out, axis_passthrough, settings);
            }
        }
        tb_color_router_output(axis_out.top, "top");       
        tb_color_router_output(axis_out.bottom, "bottom"); 
        tb_color_router_output(axis_out.left, "left"); 
        tb_color_router_output(axis_out.right, "right"); 
        printf("==> Group passthrough\n");
        while(!last) {
            while (axis_passthrough.empty());
            wide_color_axis pkt_out = axis_passthrough.read();
            color c = pkt_out.data;
            last = pkt_out.last;
            printf("Packet %d: Color = %d, last = %d\n", i++, c.to_int(), last);
        }
    }
}


int main() {
    int num_frames = 4;
    reg_settings settings;
    settings.resolution.x = 20;
    settings.resolution.y = 8;
    settings.top_bounds.x.upper = 17;
    settings.top_bounds.x.lower = 2;
    settings.top_bounds.y.upper = 1;
    settings.top_bounds.y.lower = 0;
    settings.bottom_bounds.x.upper = 17;
    settings.bottom_bounds.x.lower = 2;
    settings.bottom_bounds.y.upper = 7;
    settings.bottom_bounds.y.lower = 6;
    settings.left_bounds.x.upper = 1;
    settings.left_bounds.x.lower = 0;
    settings.left_bounds.y.upper = 5;
    settings.left_bounds.y.lower = 2;
    settings.right_bounds.x.upper = 19;
    settings.right_bounds.x.lower = 18;
    settings.right_bounds.y.upper = 5;
    settings.right_bounds.y.lower = 2;
    tb_color_router_driver(num_frames, settings);
}