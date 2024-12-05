module guitar_hero_display (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [2:0] speed_select,
    output wire hsync,
    output wire vsync,
    output reg [23:0] rgb,
    output wire [9:0] h_count,
    output wire [9:0] v_count
);

//Declare wires
wire [19:0] speed;
wire [15:0] rand;
wire [1:0] active_column;
wire [9:0] note_y_position;
wire note_active;
wire note_visible_1, note_visible_2, note_visible_3;

//Assign speed_select which is assigned to switches 3-1 to certain speeds. This allows for different dificulties.
assign speed = (speed_select == 3'b000) ? 20'hFFFFF :
               (speed_select == 3'b001) ? 20'h7FFFF :
               (speed_select == 3'b010) ? 20'h3FFFF :
               20'h1FFFF;  // Default to fastest speed to removed infered latches.

// Instantiate the VGA driver
vga_driver vga_inst (
    .clk(clk),
    .rst(rst),
	 .hsync(hsync),
	 .vsync(vsync),
	 .h_count(h_count),
	 .v_count(v_count)
);

// Instantiate the LFSR
lfsr lfsr_inst (
    .clk(clk),
	 .rst(rst),
	 .rand(rand)
);

// Instantiate the note manager
note_manager note_mgr_inst (
    .clk(clk),
	 .rst(rst),
	 .start(start),
	 .speed(speed),
	 .rand(rand),
	 .active_column(active_column),
	 .note_y_position(note_y_position),
	 .note_active(note_active)
);

// Instantiate the note generators
note_generator note_inst_1 (
    .h_count(h_count),
	 .v_count(v_count),
	 .column_start(10'd8),
	 .note_y_position(note_y_position),
	 .note_active(note_active && active_column == 2'b00),
	 .note_visible(note_visible_1)
);

note_generator note_inst_2 (
    .h_count(h_count),
	 .v_count(v_count),
	 .column_start(10'd220),
	 .note_y_position(note_y_position),
	 .note_active(note_active && active_column == 2'b01),
	 .note_visible(note_visible_2)
);

note_generator note_inst_3 (
    .h_count(h_count),
	 .v_count(v_count),
	 .column_start(10'd432),
	 .note_y_position(note_y_position),
	 .note_active(note_active && active_column == 2'b10),
	 .note_visible(note_visible_3)
);

// RGB logic to draw the screen and notes.
    always @(posedge clk or posedge rst) begin
	 
        if (rst) begin
		  
            rgb <= 24'h000000;
				
        end else if ((h_count < 640) && (v_count < 480)) begin
		  
            if (note_visible_1) begin
				
                rgb <= 24'hFF0000; // Red Note for first column
					 
            end else if (note_visible_2) begin
				
                rgb <= 24'hFFFF00; // Yellow Note for middle column
					 
            end else if (note_visible_3) begin
				
                rgb <= 24'h0000FF; // Blue Note for last column
					 
            end else if (v_count >= 380 && v_count < 384) begin
				
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
