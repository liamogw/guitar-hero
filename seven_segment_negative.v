module seven_segment_negative(in,out);

//Same seven segment negative display that we've used in labs. Should only display the middle segment.

input in;
output reg [6:0]out; // a, b, c, d, e, f, g

always @(*) begin

    case (in)
	 
	 1'b0: out = 7'b1111111;
	 
	 1'b1: out = 7'b0111111;
	 
	 default: out = 7'b1111111;
	 
	 endcase
	 
end

endmodule
