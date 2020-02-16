/*
 * This IP is the MEGA/XMEGA TOP implementation.
 * 
 * Copyright (C) 2020  Iulian Gheorghiu (morgoth@devboard.tech)
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

`timescale 1ns / 1ps

`define FLASH_ROM_FILE_NAME		"Arcade_Kong_Kong.ino.mem"
//`define SIMULATE

module top(
	input rst,
	input clk,
	//inout [7:0]pb,
	//inout [7:6]pc,
	//inout [7:0]pd,
	//inout pe2,
	//inout pe6,
	//inout [1:0]pfl,
	//inout [7:4]pfh
	inout [7:0]ja, // ja[7]=Buzzer2, ja[6]=Buzzer1, ja[5]=OledRst, ja[4]=OledCS, ja[3]=OledDC
	inout [7:0]LED, // LED[0] = Green, LED[1] = RED, LED[2] = BLUE, 
	inout [7:0]SW,// SW[0] = Button B
	inout btnc,// Button A
	inout btnd,// Button Down
	inout btnl,// Button Left
	inout btnr,// Button Right
	inout btnu, // Button Up
	
	output hdmi_tx_cec,
	output hdmi_tx_clk_n,
	output hdmi_tx_clk_p,
	input hdmi_tx_hpd,
	output hdmi_tx_rscl,
	inout hdmi_tx_rsda,
	output [2:0]hdmi_tx_n,
	output [2:0]hdmi_tx_p
	);


reg rst_reg;
wire pll_locked;
wire sys_rst = ~rst_reg | ~pll_locked;
wire sys_clk;// = clk;
wire pll_clk;// = clk;
wire hdmi_clk;// = clk;
wire clkfb;


PLLE2_BASE #(
	.BANDWIDTH("OPTIMIZED"),	// OPTIMIZED, HIGH, LOW
	.CLKFBOUT_MULT(16),			// Multiply value for all CLKOUT, (2-64)
	.CLKFBOUT_PHASE(0.0),		// Phase offset in degrees of CLKFB, (-360.000-360.000).
	.CLKIN1_PERIOD(10.0),		// Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
	// CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
	.CLKOUT0_DIVIDE(100), // Core clock 16Mhz.
	.CLKOUT1_DIVIDE(8), // PLL clock ~192Mhz.
	.CLKOUT2_DIVIDE(4), // HDMI clock.
	.CLKOUT3_DIVIDE(1),
	.CLKOUT4_DIVIDE(1),
	.CLKOUT5_DIVIDE(1),
	// CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
	.CLKOUT0_DUTY_CYCLE(0.5),
	.CLKOUT1_DUTY_CYCLE(0.5),
	.CLKOUT2_DUTY_CYCLE(0.5),
	.CLKOUT3_DUTY_CYCLE(0.5),
	.CLKOUT4_DUTY_CYCLE(0.5),
	.CLKOUT5_DUTY_CYCLE(0.5),
	// CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
	.CLKOUT0_PHASE(0.0),
	.CLKOUT1_PHASE(0.0),
	.CLKOUT2_PHASE(0.0),
	.CLKOUT3_PHASE(0.0),
	.CLKOUT4_PHASE(0.0),
	.CLKOUT5_PHASE(0.0),
	.DIVCLK_DIVIDE(1),			// Master division value, (1-56)
	.REF_JITTER1(0.0),			// Reference input jitter in UI, (0.000-0.999).
	.STARTUP_WAIT("TRUE")		// Delay DONE until PLL Locks, ("TRUE"/"FALSE")
)
PLLE2_BASE_inst (
	// Clock Outputs: 1-bit (each) output: User configurable clock outputs
	.CLKOUT0(sys_clk),			// 1-bit output: CLKOUT0
	.CLKOUT1(pll_clk),			// 1-bit output: CLKOUT1
	.CLKOUT2(hdmi_clk),			// 1-bit output: CLKOUT2
	.CLKOUT3(),					// 1-bit output: CLKOUT3
	.CLKOUT4(),					// 1-bit output: CLKOUT4
	.CLKOUT5(),					// 1-bit output: CLKOUT5
	// Feedback Clocks: 1-bit (each) output: Clock feedback ports
	.CLKFBOUT(clkfb),			// 1-bit output: Feedback clock
	.LOCKED(pll_locked),		// 1-bit output: LOCK
	.CLKIN1(clk),				// 1-bit input: Input clock
	// Control Ports: 1-bit (each) input: PLL control ports
	.PWRDWN(),					// 1-bit input: Power-down
	.RST(~rst),					// 1-bit input: Reset
	// Feedback Clocks: 1-bit (each) input: Clock feedback ports
	.CLKFBIN(clkfb)				// 1-bit input: Feedback clock
);

always @ (posedge sys_clk) 
begin
	if(~rst)
		rst_reg <= 1'b1;
	else
		rst_reg <= rst;
end


wire pb_dummy_0 = 0;
wire pb_dummy_3 = 0;
wire [5:0]pc_dummy_5_0 = 0;
wire pd_dummy_5 = 0;
wire [3:0]pd_dummy_3_0 = 0;
wire [1:0]pe_dummy_1_0 = 0;
wire pe_dummy_2 = 0;
wire [2:0]pe_dummy_5_3 = 0;
wire pe_dummy_7 = 0;
wire [3:0]pf_dummy_3_0 = 0;

/* Load/Store EEPROM content from/to external source wires */
wire [16:0]ext_load_read_eep_addr;
wire [7:0]ext_eep_data_in;
wire ext_eep_data_wr;
wire [7:0]ext_eep_data_out;
wire ext_eep_data_rd;
wire ext_eep_data_en;
wire content_modifyed;
/* !Load/Store EEPROM content from/to external source wires */

/* Debug wires */
wire [4:0]debug;
/* Debug wires */

wire lcd_clk;
wire lcd_h;
wire lcd_v;
wire lcd_de;
wire [7:0]lcd_r;
wire [7:0]lcd_g;
wire [7:0]lcd_b;
wire [12:0]lcd_h_cnt;
wire [12:0]lcd_v_cnt;
wire [31:0]ssd1306_rgb_data;

`ifndef SIMULATE
lcd #(
	.MASTER("TRUE"),
	.DEBUG(""),//"PATERN_RASTER"
	.DISPLAY_CFG("1280_720_60_DISPLAY_74_25_Mhz"),
	
	.ADDRESS(0),
	.BUS_VRAM_ADDR_LEN(24),
	.BUS_VRAM_DATA_LEN(8),
	.BUS_ADDR_DATA_LEN(16),
	
	.DINAMIC_CONFIG("FALSE"),
	.VRAM_BASE_ADDRESS_CONF(0),
	.H_RES_CONF(800),
	.H_BACK_PORCH_CONF(46),
	.H_FRONT_PORCH_CONF(210),
	.H_PULSE_WIDTH_CONF(2),
	.V_RES_CONF(480),
	.V_BACK_PORCH_CONF(23),
	.V_FRONT_PORCH_CONF(22),
	.V_PULSE_WIDTH_CONF(2),
	.PIXEL_SIZE_CONF(24),
	.HSYNK_INVERTED_CONF(1'b1),
	.VSYNK_INVERTED_CONF(1'b1),
	.DATA_ENABLE_INVERTED_CONF(1'b0),

	.DEDICATED_VRAM_SIZE(0),
	
	.FIFO_DEPTH(256)
)lcd_inst(
	.rst(sys_rst),
	.ctrl_clk(),
    .ctrl_addr(),
	.ctrl_wr(),
	.ctrl_rd(),
	.ctrl_data_in(),
	.ctrl_data_out(),

	.vmem_addr(),
	.vmem_in(),
	.vmem_out(),
	.vmem_rd(),
	.vmem_wr(),
	
	.lcd_clk(lcd_clk),
	.lcd_h_synk(lcd_h),
	.lcd_v_synk(lcd_v),
	.lcd_r(lcd_r),
	.lcd_g(lcd_g),
	.lcd_b(lcd_b),
	.lcd_de(lcd_de),
	
	.h_cnt_out(lcd_h_cnt),
	.v_cnt_out(lcd_v_cnt),
	.color_data_in(ssd1306_rgb_data)

);

hdmi_out #(
	.PLATFORM("XILINX_ARTIX_7")
	)hdmi_out_inst(
	.rst(sys_rst),
	.clk(hdmi_clk),
	.hdmi_tx_cec(hdmi_tx_cec),
	.hdmi_tx_clk_n(hdmi_tx_clk_n),
	.hdmi_tx_clk_p(hdmi_tx_clk_p),
	.hdmi_tx_hpd(hdmi_tx_hpd),
	.hdmi_tx_rscl(hdmi_tx_rscl),
	.hdmi_tx_rsda(hdmi_tx_rsda),
	.hdmi_tx_n(hdmi_tx_n),
	.hdmi_tx_p(hdmi_tx_p),
	
	.lcd_clk_out(lcd_clk),
	.lcd_h_synk(lcd_h),
	.lcd_v_synk(lcd_v),
	.lcd_r(lcd_r),
	.lcd_g(lcd_g),
	.lcd_b(lcd_b),
	.lcd_de(lcd_de)
	);
`endif
wire mosi;
wire scl;
`ifndef SIMULATE
ssd1306 # (
	.X_OLED_SIZE(128),
	.Y_OLED_SIZE(64),
	.X_PARENT_SIZE(1280),
	.Y_PARENT_SIZE(720),
	.RENDER_D_OUT_BUFFERED("TRUE"),
	.PIXEL_INACTIVE_COLOR(32'h10101010),
	.PIXEL_ACTIVE_COLOR(32'hE0E0E0E0),
	.INACTIVE_DISPLAY_COLOR(32'h10101010)
	)ssd1306_inst(
	.rst(~ja[5]),
	.clk(sys_clk),
	
	.edge_color(32'h00808080),
	.render_clk_in(sys_clk),
	.render_x_in(lcd_h_cnt),
	.render_y_in(lcd_v_cnt),
	.raster_clk(lcd_clk),
	.raster_h_synk(lcd_h),
	.raster_v_synk(lcd_v),
	.raster_de(lcd_de),
	.render_d_out(ssd1306_rgb_data),
	
	.ss(ja[4]),
	.scl(scl),
	.mosi(mosi),
	.dc(ja[3])
    );
`endif
wire ld0;
wire ld1;
wire ld2;

atmega32u4 # (
	.ROM_PATH(`FLASH_ROM_FILE_NAME),
	.USE_PIO_B("TRUE"),
	.USE_PIO_C("TRUE"),
	.USE_PIO_D("TRUE"),
	.USE_PIO_E("TRUE"),
	.USE_PIO_F("TRUE"),
	.USE_PLL("TRUE"),
	.USE_TIMER_0("TRUE"),
	.USE_TIMER_1("TRUE"),
	.USE_TIMER_3("TRUE"),
	.USE_TIMER_4("TRUE"),
	.USE_SPI_1("TRUE"),
	.USE_UART_1("FALSE"),
	.USE_EEPROM("TRUE")
) atmega32u4_inst (
	.rst(sys_rst),
	.clk(sys_clk),
	.clk_pll(pll_clk),
	.pb({ld2, ld1, ld0, SW[0], pb_dummy_3, mosi, scl, pb_dummy_0}),
	.pc({ja[7:6], pc_dummy_5_0}),
	.pd({ja[5:4], pd_dummy_5, ja[3], pd_dummy_3_0}),
	.pe({pe_dummy_7, btnc, pe_dummy_5_3, pe_dummy_2/*pe2*/, pe_dummy_1_0}),
	.pf({btnl, btnu, btnd, btnr, pf_dummy_3_0}),
	.ext_load_read_eep_addr(ext_load_read_eep_addr),
	.ext_eep_data_in(ext_eep_data_in),
	.ext_eep_data_wr(ext_eep_data_wr),
	.ext_eep_data_out(ext_eep_data_out),
	.ext_eep_data_rd(ext_eep_data_rd),
	.ext_eep_data_en(ext_eep_data_en),
	.content_modifyed(content_modifyed),
	.debug(debug)
);

assign LED[3:0] = {scl, ld2, ld1, ld0};

endmodule

