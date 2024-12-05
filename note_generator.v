module note_generator(
    input wire [9:0] h_count,
    input wire [9:0] v_count,
    input wire [9:0] column_start,
    input wire [9:0] note_y_position,
    input wire note_active,
    output reg note_visible
);

    parameter NOTE_WIDTH = 200; //Width of the note.
	 
    parameter NOTE_HEIGHT = 80; //Height of the note.

    always @* begin
	 
        note_visible = note_active && (h_count >= column_start) && (h_count < column_start + NOTE_WIDTH) && (v_count >= note_y_position) && (v_count < note_y_position + NOTE_HEIGHT);
    
	 end

endmodule
