module note_generator(
    input wire clk,
    input wire rst,
	 input wire start,
    input wire [9:0] h_count,
    input wire [9:0] v_count,
    output reg note_visible
);

    reg [9:0] note_y_position;
	 
	 reg [19:0] counter; 
	 
    parameter NOTE_WIDTH = 125;
	 
    parameter NOTE_HEIGHT = 50;
	 
    parameter COLUMN_START = 50; // Adjust based on your column position
	 
	 parameter COUNTER_MAX = 20'hFFFFF;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            note_y_position <= 0;
            counter <= 0;
        end else if (start) begin
            if (counter == COUNTER_MAX) begin
                counter <= 0;
                if (note_y_position >= 480) begin
                    note_y_position <= 0;
                end else begin
                    note_y_position <= note_y_position + 1;
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @* begin
        note_visible = (h_count >= COLUMN_START) && (h_count < COLUMN_START + NOTE_WIDTH) &&
                       (v_count >= note_y_position) && (v_count < note_y_position + NOTE_HEIGHT);
    end

endmodule
