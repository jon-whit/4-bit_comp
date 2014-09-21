`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:11:44 04/08/2014
// Design Name:   fourbit_cpu
// Module Name:   C:/Users/Jonathan/Documents/Xilinx/Projects/CPU/test_cpu.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fourbit_cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_cpu;

	// Inputs
	reg clk;
	reg clr;
	reg [7:0] sw;
	reg [1:0] btn;

	// Outputs
	wire [3:0] led;
	wire decimal;
	wire [3:0] enable;
	wire [6:0] segs;

	// Instantiate the Unit Under Test (UUT)
	fourbit_cpu uut (
		.clk(clk), 
		.clr(clr), 
		.sw(sw), 
		.btn(btn), 
		.led(led), 
		.decimal(decimal), 
		.enable(enable), 
		.segs(segs)
	);

	initial begin
		$display("Simulation has Started..");
		
		// Initialize Inputs
		clk = 0;
		clr = 0;
		sw = 0;
		btn = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		clr = 1'b1;
		#30;  
		clr = 1'b0;
		
		// Test user mode.
		// **************************************************************
		
		// Test load
		sw = 8'b00000100;	// R[0] <- 4
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		
		sw = 8'b00010011;	// R[1] <- 3
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		
		sw = 8'b00100010;	// R[2] <- 2
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		
		sw = 8'b00110001;	// R[3] <- 1
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		// **************************************************************
		
		// Test store
		// **************************************************************
		sw = 8'b01000000;	// LEDS <- R[0] = 4
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		// **************************************************************
		
		// Test move
		sw = 8'b10010000; // R[1] <- R[0] = 4
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#100;
		
		// Test ALU operations.
		// **************************************************************
		
		// add
		sw = 8'b11111000; // R[3] <- R[3] + R[2] = 1 + 2
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#120;
		
		// sub
		sw = 8'b11000101; // R[0] <- R[0] - R[1] = 4 - 4
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#120;
		
		// and
		sw = 8'b11101110; // R[2] <- R[2] & R[3] = 10 & 11 = 2
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#120;
		
		// not
		sw = 8'b11010011; // R[1] <- ~R[1] = ~(0100) = 1011 = 11
		btn = 2'b01;
		#40;
		btn = 2'b00;
		#120;
		// **************************************************************
		
		// Test run mode
		// **************************************************************
		clr = 1'b1;
		#30;
		
		clr = 1'b0;
		btn = 2'b10;
		#30;
		
		btn = 2'b00;
		// **************************************************************
		
		$display("Simulation has Ended.");
	end
	
	always
		#20 clk <= ~clk;
      
endmodule

