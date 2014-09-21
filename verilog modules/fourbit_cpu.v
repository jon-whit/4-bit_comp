`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////	
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    17:51:49 04/07/2014 
// Module Name:    fourbit_cpu 
// Description: 	 This verilog module implements a 4-bit cpu with manual instruction
//						 entry or ROM instruction entry.
//////////////////////////////////////////////////////////////////////////////////
module fourbit_cpu(clk, clr, sw, btn, led, decimal, enable, segs);

	// Inputs.
	input clk, clr;
	input [7:0] sw;
	input [1:0] btn;
	
	// Outputs.
	output [3:0] led, enable;
	output [6:0] segs;
	output decimal;
	
	// Internal wires.
	wire [3:0] Rin, Rout, usr_Data, run_Data, BUS, G, Aoper, ALUout;
	wire LEDRegEn, Ain, Gin, Gout, usr_load, run_load, inst_done, rom_done;
	wire [1:0] ALUOp, bin;
	wire [3:0] Q[3:0];
	wire [7:0] rom_inst;
	
	// Debounce the push button inputs.
	DeBouncer btn0(clk, clr, btn[0], bin[0]);
	DeBouncer btn1(clk, clr, btn[1], bin[1]);
	
	// 7-segment display.
	LED_7SEG seg(clk, clr, Q[0], Q[1], Q[2], Q[3], decimal, enable, segs);
	
	// Internal rom module.
	internal_rom rom(clk, clr, inst_done, rom_inst, rom_done);
	
	// CPU controller.
	cpu_controller ctrl(clk, clr, bin, sw, rom_inst, 1'b1, rom_done, LEDRegEn, Rin, Rout, Ain, Gin, Gout, usr_load, run_load, usr_Data, run_Data, ALUOp, inst_done);
	
	// General registers.
	regn R0(BUS, Rin[0], clk, clr, Q[0]);
	regn R1(BUS, Rin[1], clk, clr, Q[1]);
	regn R2(BUS, Rin[2], clk, clr, Q[2]);
	regn R3(BUS, Rin[3], clk, clr, Q[3]);
	
	// Tri-state buffers.
	trin T0(Q[0], Rout[0], BUS);
	trin T1(Q[1], Rout[1], BUS);
	trin T2(Q[2], Rout[2], BUS);
	trin T3(Q[3], Rout[3], BUS);
	trin TG(G, Gout, BUS);
	trin TUL(usr_Data, usr_load, BUS);
	trin TRL(run_Data, run_load, BUS);
	
	// LED register.
	regn LEDReg(BUS, LEDRegEn, clk, clr, led);
	
	// ALU registers.
	regn regA(BUS, Ain, clk, clr, Aoper); // Aoper = Operand(A)
	regn regG(ALUout, Gin, clk, clr, G);
	
	// ALU
	ALU alu(Aoper, BUS, ALUOp, ALUout);

endmodule
