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

    // Generate white screen
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rgb <= 24'h0000000; // Black during reset
				
				
        end else if ((h_count < 4) && (v_count < 480)) begin
            rgb <= 24'h0000000; // Left side of the screen (Black)
        
		  end else if ((h_count < 212) && (h_count > 4) &&(v_count < 480)) begin
				rgb <= 24'h00D5FF; // First note column (Blue)
				
		  end else if ((h_count < 217) && (h_count > 212) && (v_count < 480)) begin
		  
				rgb <= 24'h0000000; // Black spacing (Black)
		  
		  end else if ((h_count < 424) && (h_count > 217) && (v_count < 480)) begin
		  
				rgb <= 24'hFF8900; //Second note column (orange)
		
		  end else if ((h_count < 428) && (h_count > 424) && (v_count < 480)) begin
				
				rgb <= 24'h0000000; // (Black)
				
		  end else if ((h_count < 636) && (h_count > 428) && (v_count < 480)) begin
				
				rgb <= 24'h00D5FF; // third note column (blue)
		  
		  end else if ((h_count < 640) && (h_count > 636) & (v_count < 480)) begin
		  
				rgb <= 24'h0000000; // (black)
		  
		  end else begin
            rgb <= 24'h0000000; //  outside the active area
        end
    end

endmodule
