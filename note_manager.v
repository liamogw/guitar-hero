module note_manager(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [19:0] speed,
    input wire [15:0] rand,
    output reg [1:0] active_column,
    output reg [9:0] note_y_position,
    output reg note_active,
    output reg note_missed,
    output reg note_hit,
    output reg game_over
);

//We needed this note manager to handle each note and their respective scoring abilities. This means you can only gain points by pressing the right key for the right note.

    parameter SPAWN_THRESHOLD = 16'h8000;
	 
    parameter TOTAL_NOTES = 30; //This allows us to end the game after 30 notes. Because of the LFSR we created sometimes a note wont actually fall but will count for the total notes. This gives you a rough amount of game time.

    reg [19:0] counter;
	 
    reg [4:0] notes_generated;
	 
    reg [4:0] notes_fallen;
	 
    always @(posedge clk or posedge rst) begin
	 
        if (rst) begin
		  
            active_column <= 2'b00;
				
            note_y_position <= 0;
				
            note_active <= 0;
				
            counter <= 0;
				
            note_missed <= 0;
				
            note_hit <= 0;
				
            notes_generated <= 0;
				
            notes_fallen <= 0;
				
            game_over <= 0;
				
        end else if (start && !game_over) begin
		  
            if (counter >= speed) begin 
				
                counter <= 0;
					 
                if (note_active) begin
					 
                    if (note_y_position >= 480) begin
						  
                        note_active <= 0;
								
                        note_missed <= 1;
								
                        notes_fallen <= notes_fallen + 1;
								
                        if (notes_fallen == TOTAL_NOTES - 1) begin
								
                            game_over <= 1;
									 
                        end
								
                    end else begin
						  
                        note_y_position <= note_y_position + 1;
								
                    end
						  
                end else if (rand > SPAWN_THRESHOLD && notes_generated < TOTAL_NOTES) begin
					 
                    note_active <= 1;
						  
                    note_y_position <= 0;
						  
                    active_column <= rand[1:0];
						  
                    note_missed <= 0;
						  
                    note_hit <= 0;
						  
                    notes_generated <= notes_generated + 1;
						  
                end
					 
            end else begin
				
                counter <= counter + 1;
					 
            end
        end
    end

endmodule
