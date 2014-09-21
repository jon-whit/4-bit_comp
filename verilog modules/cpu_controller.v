`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////
// Engineer: 		 Jonathan Whitaker
// 
// Create Date:    17:43:13 04/07/2014 
// Module Name:    cpu_controller 
// Description: 	 This verilog module implements a 4-bit CPUs controller unit.
//
////////////////////////////////////////////////////////////////////////////////////////////
module cpu_controller(clk, clr, btn, usr_inst, rom_inst, En, rom_done, LEDRegEn, Rin, Rout, 
							 Ain, Gin, Gout, load_usr, load_rom, usr_Data, rom_Data, ALUOp, inst_done);

	// Inputs.
	input clk, clr, En, rom_done;
	input [7:0] usr_inst;	// The incoming instruction from the user.
	input [7:0] rom_inst;	// The incoming instruction from the ROM.
							
	input [1:0] btn;			// Selects user mode (01) or run mode (10).
	
	// Outputs.
	output reg LEDRegEn, Ain, Gin, Gout, load_usr, load_rom, inst_done;
	output reg [3:0] Rin, Rout;
	output reg [1:0] ALUOp;
	output [3:0] usr_Data, rom_Data;
	
	// Declare the 15 state parameters.
	//*********************************
	parameter idle = 4'b0000, 
				 usr_mode = 4'b0001, 
				 usr_load = 4'b0010, 
				 usr_str = 4'b0011, 
				 usr_mv  = 4'b0100, 
				 usr_aluop = 4'b0101, 
				 usr_aluwr = 4'b0110,
				 run_mode = 4'b0111, 
				 run_fetch = 4'b1000, 
				 run_exec = 4'b1001, 
				 run_load = 4'b1010, 
				 run_str = 4'b1011, 
				 run_mv = 4'b1100, 
				 run_aluop = 4'b1101, 
				 run_aluwr = 4'b1110;
	//*********************************
					
	reg [3:0] PS, NS;
	
	// Assign the user instruction parameters.
	wire [1:0] usr_opcode, usr_Rx, usr_Ry, usr_funct;
	wire [3:0] usr_Data;
	assign usr_opcode = usr_inst[7:6];
	assign usr_Rx = usr_inst[5:4];
	assign usr_Ry = usr_inst[3:2];
	assign usr_Data = usr_inst[3:0];
	assign usr_funct = usr_inst[1:0];
	
	// Assign the rom instruction parameters.
	wire [1:0] rom_opcode, rom_Rx, rom_Ry, rom_funct;
	wire [3:0] rom_Data;
	assign rom_opcode = rom_inst[7:6];
	assign rom_Rx = rom_inst[5:4];
	assign rom_Ry = rom_inst[3:2];
	assign rom_Data = rom_inst[3:0];
	assign rom_funct = rom_inst[1:0];
	
	// NS
	always@(*)
		if(En)
			case(PS)
				idle: NS = btn[0] ? usr_mode: (btn[1] ? run_mode: idle);
				
				// User mode.
				usr_mode:
					if(btn[0])
						NS = usr_mode;
					else
						case(usr_opcode)
							0:	NS = usr_load;
							1:	NS = usr_str;
							2:	NS = usr_mv;
							3:	NS = usr_aluop;
							default:
								NS = usr_mode;
						endcase
				usr_load: NS = idle;
				usr_str: NS = idle;
				usr_mv: NS = idle;
				usr_aluop: NS = usr_aluwr;
				usr_aluwr: NS = idle;
				
				// Run mode.
				run_mode: 
					if(btn[1])
						NS = run_mode;
					else
						NS = run_fetch;
				run_fetch: NS = rom_done ? idle: run_exec;
				run_exec:
					case(rom_opcode)
						0:	NS = run_load;
						1:	NS = run_str;
						2:	NS = run_mv;
						3:	NS = run_aluop;
						default:
							NS = run_exec;
					endcase
				run_load: NS = rom_done ? idle: run_fetch;
				run_str: NS = rom_done ? idle: run_fetch;
				run_mv: NS = rom_done ? idle: run_fetch;
				run_aluop: NS = run_aluwr;
				run_aluwr: NS = rom_done ? idle: run_fetch;
				default: NS = idle;
			endcase
		else
			NS = idle;
	
	// PS
	always@(posedge clk)
		if(clr) PS <= idle;
		else PS <= NS;
		
	// Control line outputs
	always@(*)
	begin
		LEDRegEn = 1'b0;
		Ain = 1'b0;
		load_usr = 1'b0; load_rom = 1'b0;
		inst_done = 1'b0;
		Gin = 1'b0; Gout = 1'b0;
		Rin = 4'b0000; Rout = 4'b0000;
		ALUOp = 2'b00;
		
		case(PS)
			// user mode outputs.
			//*********************************
			usr_mode:
			begin
					// A <- [Rx]
					case(usr_Rx)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				Ain = 1'b1;
			end
			
			usr_load:
			begin
				load_usr = 1'b1;
				
				case(usr_Rx)
					0: Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
			end
			
			usr_str:
			begin
				LEDRegEn = 1'b1;
			
				case(usr_Rx)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
			end
			
			usr_mv:
			begin
				case(usr_Ry)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				case(usr_Rx)
					0:	Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
			end
			
			usr_aluop:
			begin
				// Bus <- [Ry]
				case(usr_Ry)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				ALUOp = usr_funct;
				Gin = 1'b1;
			end
			
			usr_aluwr:
			begin
				Gout = 1'b1;
				
				case(usr_Rx)
					0:	Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
			end
			//*********************************
			
			// run mode outputs.
			//*********************************
			run_exec:
			begin
					// A <- [Rx]
					case(rom_Rx)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				Ain = 1'b1;
			end
			
			run_load:			
			begin
				load_rom = 1'b1;
				
				case(rom_Rx)
					0: Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
				
				// Indicate the instruction has finished.
				inst_done = 1'b1;
			end
			
			run_str:			
			begin
				LEDRegEn = 1'b1;
			
				case(rom_Rx)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				// Indicate the instruction has finished.
				inst_done = 1'b1;
			end
			
			run_mv:
			begin
				case(rom_Ry)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				case(rom_Rx)
					0:	Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
				
				// Indicate the instruction has finished.
				inst_done = 1'b1;
			end
			
			run_aluop:
			begin
				// Bus <- [Ry]
				case(rom_Ry)
					0:	Rout[0] = 1'b1;
					1:	Rout[1] = 1'b1;
					2:	Rout[2] = 1'b1;
					3:	Rout[3] = 1'b1;
					default:;
				endcase
				
				ALUOp = rom_funct;
				Gin = 1'b1;
			end
			
			run_aluwr:
			begin
				Gout = 1'b1;
				
				case(rom_Rx)
					0:	Rin[0] = 1'b1;
					1:	Rin[1] = 1'b1;
					2:	Rin[2] = 1'b1;
					3:	Rin[3] = 1'b1;
					default:;
				endcase
				
				// Indicate the instruction has finished.
				inst_done = 1'b1;
			end
			
			default:;
		endcase
			//*********************************
	end
			
endmodule
