module guitar_hero_display (
    input wire clk,
    input wire rst,
    output wire hsync,
    output wire vsync,
    output reg [11:0] rgb,
    output wire [9:0] h_count,
    output wire [9:0] v_count
);

    // Instantiate the VGA driver
    vga_driver vga_inst (
        .clk(clk),
        .rst(rst),
        .hsync(hsync),
        .vsync(vsync),
        .h_count(h_count),
        .v_count(v_count)
    );

    // Generate white screen
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rgb <= 12'h000; // Black during reset
        end else if ((h_count < 640) && (v_count < 480)) begin
            rgb <= 12'hFFF; // White in the active display area
        end else begin
            rgb <= 12'h000; // Black outside the active area
        end
    end

endmodule
