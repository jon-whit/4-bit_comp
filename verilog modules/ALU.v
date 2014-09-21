`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    17:20:08 04/07/2014 
// Module Name:    ALU 
// Description: 	 This verilog module implements an ALU that can perform up to 4
//						 different operations.
//////////////////////////////////////////////////////////////////////////////////
module ALU(A, B, ALUOp, G);

	parameter n = 4;
	
	// Inputs.
	input [n-1:0] A, B;
	input [1:0] ALUOp;
	
	// Outputs.
	output reg [n-1:0] G;
	
	always@(*)
		case(ALUOp)
			0:	G = A + B;
			1:	G = A - B;
			2:	G = A & B;
			3:	G = ~A;
			default: G = 'bx;
		endcase
	

	
endmodule
