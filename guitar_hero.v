module guitar_hero (

	//////////// ADC //////////
	//output		          		ADC_CONVST,
	//output		          		ADC_DIN,
	//input 		          		ADC_DOUT,
	//output		          		ADC_SCLK,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// CLOCK //////////
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	//output		    [12:0]		DRAM_ADDR,
	//output		     [1:0]		DRAM_BA,
	//output		          		DRAM_CAS_N,
	//output		          		DRAM_CKE,
	//output		          		DRAM_CLK,
	//output		          		DRAM_CS_N,
	//inout 		    [15:0]		DRAM_DQ,
	//output		          		DRAM_LDQM,
	//output		          		DRAM_RAS_N,
	//output		          		DRAM_UDQM,
	//output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	//output		     [6:0]		HEX5,

	//////////// IR //////////
	//input 		          		IRDA_RXD,
	//output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	//inout 		          		PS2_CLK,
	//inout 		          		PS2_CLK2,
	//inout 		          		PS2_DAT,
	//inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Video-In //////////
	//input 		          		TD_CLK27,
	//input 		     [7:0]		TD_DATA,
	//input 		          		TD_HS,
	//output		          		TD_RESET_N,
	//input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_1
);

//Other Necessary Wires

wire [16:0] score;
wire [9:0] h_count;
wire [9:0] v_count;
wire display_area;

wire clk_50;
assign clk_50 = CLOCK_50;

reg clk_25;

wire rst;
assign rst = ~KEY[3];


assign VGA_CLK = clk_25;
assign VGA_BLANK_N = display_area;
assign VGA_SYNC_N = 1'b0;

assign display_area = (h_count < 640) && (v_count < 480);

wire [6:0] seg7_dig0, seg7_dig1, seg7_dig2, seg7_dig3, seg7_neg;

assign HEX0 = seg7_dig0;
assign HEX1 = seg7_dig1;
assign HEX2 = seg7_dig2;
assign HEX3 = seg7_dig3;
assign HEX4 = seg7_neg;

wire note_hit;

wire game_over;
wire game_active;




// Clock divider for 25MHz
always @(posedge clk_50 or posedge rst) begin
    if (rst) begin
        clk_25 <= 0;
    end else begin
        clk_25 <= ~clk_25;
    end
end

//Concatinated rgb value
wire [23:0] rgb;
assign {VGA_R, VGA_G, VGA_B} = rgb;


//Display Inst.

guitar_hero_display display_inst (
    .clk(clk_25),
    .rst(rst),
    .start(SW[9]),
	 .speed_select(SW[3:1]),
    .hsync(VGA_HS),
    .vsync(VGA_VS),
    .rgb(rgb),
    .h_count(h_count),
    .v_count(v_count),
	 .KEY(KEY[2:0]),
	 .score(score),
	 .note_hit(note_hit),
    .note_hit_out(note_hit),
	 .game_over(game_over),
	 .game_active(game_active)
);

//Display Inst

four_decimal_vals score_display(
    .val(score),
    .seg7_dig0(seg7_dig0),
    .seg7_dig1(seg7_dig1),
    .seg7_dig2(seg7_dig2),
    .seg7_dig3(seg7_dig3),
	 .seg7_neg(seg7_neg)
);

// Audio controller instantiation
audio_controller audio_ctrl_inst (
    .clk(CLOCK_50),
    .rst(rst),
    .button_press(~KEY[2:0]),
    .AUD_XCK(AUD_XCK),
    .AUD_DACDAT(AUD_DACDAT),
    .AUD_DACLRCK(AUD_DACLRCK),
    .AUD_BCLK(AUD_BCLK),
    .FPGA_I2C_SCLK(FPGA_I2C_SCLK),
    .FPGA_I2C_SDAT(FPGA_I2C_SDAT)
);

endmodule
