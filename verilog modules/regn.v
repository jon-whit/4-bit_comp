`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    17:09:23 04/07/2014 
// Module Name:    regn 
// Description: 	 This verilog module implements an n-bit register.
//////////////////////////////////////////////////////////////////////////////////
module regn(R, L, clk, clr, Q);

	parameter n = 4;
	
	// Inputs.
	input clk, clr, L;
	input [n-1:0] R;
	
	// Outputs.
	output reg [n-1:0] Q;
	
	always@(posedge clk)
		if(clr)
			Q <= 0;
		else if(L)
			Q <= R;


endmodule
