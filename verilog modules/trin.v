`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    17:05:26 04/07/2014 
// Module Name:    trin 
// Description: 	 This verilog module implements an n-bit Tri-state buffer.
//////////////////////////////////////////////////////////////////////////////////
module trin(Y, E, F);

	parameter n = 4;
	
	// Inputs.
	input E;
	input [n-1:0] Y;
	
	// Outputs.
	output tri [n-1:0] F;

	assign F = E ? Y: 'bz;
	
endmodule
