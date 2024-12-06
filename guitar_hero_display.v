module guitar_hero_display (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [2:0] speed_select,
	 input wire [2:0] KEY,
    output wire hsync,
    output wire vsync,
    output reg [23:0] rgb,
    output wire [9:0] h_count,
    output wire [9:0] v_count,
	 output reg [16:0] score,
	 input wire note_hit,
	 output reg note_hit_out,
	 output wire game_over,
	 output reg game_active
);

//Other Necessary wires and assignments
wire [19:0] speed;

wire [15:0] rand;

wire [1:0] active_column;

wire [9:0] note_y_position;

wire note_active;

wire note_visible_1, note_visible_2, note_visible_3;

wire [2:0] button_press;

reg [2:0] last_button_state;

wire in_perfect_zone, in_good_zone, in_bad_zone; 

reg [19:0] cooldown_counter;

//Assign different speeds to speed_select which is connected to SW[2:1]
assign speed = (speed_select == 3'b000) ? 20'h8FFFF :
               (speed_select == 3'b001) ? 20'h4FFFF :
               (speed_select == 3'b010) ? 20'h0AFFF :
                20'h1FFFF;  // Default to fastest speed
					 
assign in_perfect_zone = (note_y_position >= 370 && note_y_position < 390);

assign in_good_zone = (note_y_position >= 350 && note_y_position < 410);

assign in_bad_zone = (note_y_position <= 200);

assign button_press = ~KEY & ~last_button_state;

wire note_manager_game_over;
 
assign game_over = note_manager_game_over;


//Game and scoring logic

//This Cooldown period limits the amount of time the score is added (needed this because the score was adding by thousands of point when it sould only add somewhere less than 10)
parameter COOLDOWN_PERIOD = 20'd500000;

 always @(posedge clk or posedge rst) begin
 
    if (rst) begin
	 
        last_button_state <= 3'b111;
		  
        score <= 17'd0;
		  
        cooldown_counter <= 20'd0;
		  
		  note_hit_out <= 0;
		  
		  game_active <= 1'b1;
	 
	 end else if (game_over) begin
	 
		  game_active <= 1'b0;
		  
    end else begin
	 
        last_button_state <= KEY;
        
        if (cooldown_counter == 0) begin
		  
            if (note_active) begin
				
                if (button_press[0] && active_column == 2'b10 || button_press[1] && active_column == 2'b01 || button_press[2] && active_column == 2'b00) begin
					 
                    if (in_perfect_zone) begin
						  
                        score <= score + 17'd2;  // Perfect hit
								
								note_hit_out <= 1;
								
                        cooldown_counter <= COOLDOWN_PERIOD;
								
                    end else if (in_good_zone) begin
						  
                        score <= score + 17'd1;   // Good hit
								
								note_hit_out <= 1;
								
                        cooldown_counter <= COOLDOWN_PERIOD;
								
						  end else if (in_bad_zone) begin
						  
								score <= score - 17'd1;
								
								note_hit_out <= 1;
								
								cooldown_counter <= COOLDOWN_PERIOD;
								
                    end
                end
            end
				
        end else begin
		  
            cooldown_counter <= cooldown_counter - 1;
				
        end
    end
end

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
        .note_active(note_active),
		  .note_hit(note_hit),
		  .game_over(note_manager_game_over)
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

    // RGB logic remains the same
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
