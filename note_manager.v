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
	 output reg note_hit
);

    parameter SPAWN_THRESHOLD = 16'h8000;  // Adjust this to control note frequency
    
    reg [19:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active_column <= 2'b00;
            note_y_position <= 0;
            note_active <= 0;
            counter <= 0;
				note_missed <= 0;
				note_hit <= 0;
        end else if (start) begin
            if (counter >= speed) begin 
                counter <= 0;
                if (note_active) begin
                    if (note_y_position >= 480) begin
                        note_active <= 0;
                        note_missed <= 1;
                    end else begin
                        note_y_position <= note_y_position + 1;
                    end
                end else if (rand > SPAWN_THRESHOLD) begin
                    note_active <= 1;
                    note_y_position <= 0;
                    active_column <= rand[1:0];
                    note_missed <= 0;
                    note_hit <= 0;
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
