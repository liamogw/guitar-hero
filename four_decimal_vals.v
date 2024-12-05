module four_decimal_vals (
    input [15:0] val,
    output [6:0] seg7_dig0,
    output [6:0] seg7_dig1,
    output [6:0] seg7_dig2,
    output [6:0] seg7_dig3
);

reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hundred_digit;
reg [3:0] result_thousand_digit;

/* convert the binary value into 4 signals */
always @(*) begin
    result_thousand_digit = (val / 1000) % 10;
    result_hundred_digit = (val / 100) % 10;
    result_ten_digit = (val / 10) % 10;
    result_one_digit = val % 10;
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

endmodule
