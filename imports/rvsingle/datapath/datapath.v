module datapath (
	clk,
	reset,
	ResultSrc,
	PCSrc,
	ALUSrc,
	RegWrite,
	ImmSrc,
	ALUControl,
	BCond,
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
	input wire clk;
	input wire reset;
	input wire [1:0] ResultSrc;
	input wire [1:0] PCSrc;
	input wire ALUSrc;
	input wire RegWrite;
	input wire [2:0] ImmSrc;
	input wire [3:0] ALUControl;
	output wire BCond;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	
	input wire StoreSrc;  // used to select whole 32bit register word (0) or half / byte (1) for store inst.
	input wire [2:0] DataSrc;     // select data extender mode
	input wire DataExtSrc;    // used to select data extender block source (0 for store inst. 1 for load inst.)
	input wire [1:0] RegDataSrc;    // select Reg file write source (0: load; 1: auipc; 2: lui)
	
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCTarget_1;
	wire [31:0] ImmExt;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [31:0] rd2;
	wire [31:0] dataextinput;
	wire [31:0] dataextoutput;
	wire [31:0] wd3;
	
	flopr #(32) pcreg(
		clk,
		reset,
		PCNext,
		PC
	);
	adder pcadd4(
		PC,
		32'd4,
		PCPlus4
	);
	adder pcaddbranch(
		PC,
		ImmExt,
		PCTarget_1
	);
	mux3 #(32) pcmux(
		ALUResult,
		PCTarget_1,
		PCPlus4,
		PCNext
	);
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.a1(Instr[19:15]),
		.a2(Instr[24:20]),
		.a3(Instr[11:7]),
		.wd3(wd3),
		.rd1(SrcA),
		.rd2(rd2)
	);
	immExtend iext(
		Instr[31:7],
		ImmSrc,
		Instr[14:12],     // funct3
		Instr[4],            // opb4 (to differenciate load inst. vs imm. inst.) 
		ImmExt
	);
	mux2 #(32) srcbmux(
		rd2,
		ImmExt,
		ALUSrc,
		SrcB
	);
	mux2 #(32) storemux(
	   rd2,
	   dataextoutput,
	   StoreSrc,
	   WriteData
	);
	mux2 #(32) dataextmux(
	   rd2,
	   ReadData,
	   DataExtSrc,
	   dataextinput
	);
	dataExtend dext(
	   DataSrc,
	   dataextinput,
	   dataextoutput
	);
	alu alu(
		.SrcA(SrcA),
		.SrcB(SrcB),
		.ALUControl(ALUControl),
		.ALUResult(ALUResult),
		.BCond(BCond)
	);
	mux3 #(32) resultmux(
		ALUResult,
		dataextoutput,
		PCPlus4,
		ResultSrc,
		Result
	);
	mux3 #(32) rfwritemux(
		Result,
		PCTarget_1,
		ImmExt,
		RegDataSrc,
		wd3
	);
	
endmodule
