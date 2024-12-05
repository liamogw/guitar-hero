module lfsr(
    input wire clk,
    input wire rst,
    output reg [15:0] rand
);
//Create LFSR to randomly chose a note to fall. This is instantiated.
    always @(posedge clk or posedge rst) begin
	 
        if (rst) begin
		  
            rand <= 16'hACE1; // seed value
				
        end else begin
		  
            rand[0] <= rand[15];
				
            rand[1] <= rand[0];
				
            rand[2] <= rand[1];
				
            rand[3] <= rand[2];
				
            rand[4] <= rand[3] ^ rand[15];
				
            rand[5] <= rand[4] ^ rand[15];
				
            rand[14:6] <= rand[13:5];
				
            rand[15] <= rand[14] ^ rand[15];
				
        end
    end

endmodule
