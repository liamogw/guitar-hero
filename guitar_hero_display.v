module guitar_hero_display (
    input wire clk,
    input wire rst,
    output wire hsync,
    output wire vsync,
    output reg [23:0] rgb,
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
	 
        rgb <= 24'h000000; // Black during reset
		  
    end else if ((h_count < 640) && (v_count < 480)) begin
	 
        if (v_count >= 380 && v_count < 384) begin
		  
            rgb <= 24'h000000; // Window for notes (horizontal black line)
				
        end else if (h_count < 4) begin
		  
            rgb <= 24'h000000; // Left side of the screen (Black)
				
        end else if (h_count < 212) begin
		  
            rgb <= 24'hFFFFFF; // First note column
				
        end else if (h_count < 217) begin
		  
            rgb <= 24'h000000; // Black spacing
				
        end else if (h_count < 424) begin
		  
            rgb <= 24'hFFFFFF; // Second note column 
				
        end else if (h_count < 428) begin
		  
            rgb <= 24'h000000; // Black spacing
				
        end else if (h_count < 636) begin
		  
            rgb <= 24'hFFFFFF; // Third note column 
				
        end else begin
		  
            rgb <= 24'h000000; // Right side of the screen (Black)
        end
		  
    end else begin
	 
        rgb <= 24'h000000; // Outside the active area
    end
end


endmodule
