module four_decimal_vals (
    input [16:0] val,
    output [6:0] seg7_dig0,
    output [6:0] seg7_dig1,
    output [6:0] seg7_dig2,
    output [6:0] seg7_dig3,
	 output [6:0] seg7_neg
);

//Declare reg's for each digit place.
reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hundred_digit;
reg [3:0] result_thousand_digit;
reg result_is_negative;

//Decare a two's compliment variable to use for negative values if needed.
reg [16:0] twos_comp;

//convert the binary value into 4 signals

always @(*) begin
	 
	 //If the biinary number is negative
	 if (val[16] == 1'b1) begin
	 
			result_is_negative = 1'b1;
			
			twos_comp = -val;
	 
	 end else begin
	 
			result_is_negative = 1'b0;
			
			twos_comp = val;
	 
	 end

    result_thousand_digit = (twos_comp / 1000) % 10;
	 
    result_hundred_digit = (twos_comp / 100) % 10;
	 
    result_ten_digit = (twos_comp / 10) % 10;
	 
    result_one_digit = twos_comp % 10;
	 
end

/* instantiate the modules for each of the seven seg decoders */
seven_segment dig0(
    .in(result_one_digit),
    .out(seg7_dig0)
);

seven_segment dig1(
    .in(result_ten_digit),
    .out(seg7_dig1)
);

seven_segment dig2(
    .in(result_hundred_digit),
    .out(seg7_dig2)
);

seven_segment dig3(
    .in(result_thousand_digit),
    .out(seg7_dig3)
);

seven_segment_negative neg(
    .in(result_is_negative),
    .out(seg7_neg)
);

endmodule
