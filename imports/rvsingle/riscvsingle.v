module riscvsingle (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire ALUSrc;
	wire RegWrite;
	wire Jump;
	wire BCond;
	wire [1:0] ResultSrc;
	wire [2:0] ImmSrc;
	wire [3:0] ALUControl;
	wire [1:0] PCSrc;
	wire StoreSrc;             // used to select whole 32bit register word (0) or half / byte (1) for store inst.
	wire [2:0] DataSrc;     // select data extender mode
	wire DataExtSrc;    // used to select data extender block source (0 for store inst. 1 for load inst.)
	wire [1:0] RegDataSrc;    // select Reg file write source (0: load; 1: auipc; 2: lui)
	
	controller c(
		Instr[6:0],
		Instr[14:12],
		Instr[30],
		BCond,
		ResultSrc,
		MemWrite,
		PCSrc,
		ALUSrc,
		RegWrite,
		Jump,
		ImmSrc,
		ALUControl,
		StoreSrc,
	    DataSrc,
	    DataExtSrc,
	    RegDataSrc
	);
	
	datapath dp(
		clk,
		reset,
		ResultSrc,
		PCSrc,
		ALUSrc,
		RegWrite,
		ImmSrc,
		ALUControl,
		Zero,
		PC,
		Instr,
		ALUResult,
		WriteData,
		ReadData,
		StoreSrc,
	    DataSrc,
	    DataExtSrc,
	    RegDataSrc
	);
endmodule
