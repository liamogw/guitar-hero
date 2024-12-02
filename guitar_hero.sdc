create_clock -period 20.000 -name CLOCK_50 [get_ports CLOCK_50]
create_generated_clock -name clk_25 -source [get_ports CLOCK_50] -divide_by 2 [get_pins clk_div|clk_out]
