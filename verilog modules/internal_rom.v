`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    11:48:41 04/09/2014 
// Module Name:    internal_rom 
// Description: 	 This verilog module implements an internal ROM that is used with
//						 the 4-bit CPU.
//////////////////////////////////////////////////////////////////////////////////
module internal_rom(clk, clr, inst_done, rom_inst, rom_done);

	// Inputs.
	input clk, clr, inst_done;
	
	// Outputs.
	output reg [7:0] rom_inst;
	output reg rom_done;

	// Internal wires etc..
	reg [3:0] PC;
	
	// Program counter.
	always@(posedge clk)
		if(clr)
			PC <= 0;
		else if(~rom_done)
		begin
			if(inst_done & (PC < 10))
				PC <= PC + 1;
		end
		else 
			PC <= 0;
	
	always@(*)
	begin
		rom_done = 1'b0;
		
		case(PC)
		/*
			Final values:
			R0 = 6
			R1 = 1
			R2 = 2
			R3 = 2
			LEDS = 6
		 */
		   0:	rom_inst = 8'b00000101; // R0 <- 5		
			1:	rom_inst = 8'b00010100;	// R1 <- 4
			2:	rom_inst = 8'b00100011;	// R2 <- 3
			3: rom_inst = 8'b00110010; // R3 <- 2
			4:	rom_inst = 8'b11011001;	// R1 <- [R1] - [R2] = 4 - 3 = 1
			5:	rom_inst = 8'b11000100;	// R0 <- [R0] + [R1] = 5 + 1 = 6
			6: rom_inst = 8'b11101110;	// R2 <- [R2] & [R3] = 0011 & 0010 = 0010 = 2
			7:	rom_inst = 8'b11010011;	// R1 <- !R1 = 14
			8: rom_inst = 8'b01000000;	// LEDS <- R0 = 6
			9: rom_inst = 8'b10000100;	// R0 <- R1
			default: 
			begin
				rom_done = 1'b1;	// Send the done signal.
				rom_inst = 8'b10000000;
			end
		endcase
	end
endmodule
