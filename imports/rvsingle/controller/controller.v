module controller (
	op,
	funct3,
	funct7b5,
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
	input wire [6:0] op;
	input wire [2:0] funct3;
	input wire funct7b5;
	input wire BCond;
	output wire [1:0] ResultSrc;
	output wire MemWrite;
	output wire [1:0] PCSrc;
	output wire ALUSrc;
	output wire RegWrite;
	output wire Jump;
	output wire [2:0] ImmSrc;
	output wire [3:0] ALUControl;
	
	// aditional signals
	output wire StoreSrc;  // used to select whole 32bit register word (0) or half / byte (1) for store inst.
	output wire [2:0] DataSrc;     // select data extender mode
	output wire DataExtSrc;    // used to select data extender block source (0 for store inst. 1 for load inst.)
	output wire [1:0] RegDataSrc;    // select Reg file write source (0: load; 1: auipc; 2: lui)
	
	wire [1:0] ALUOp;
	wire Branch;
	
	maindec md(
		.op(op),
		.ResultSrc(ResultSrc),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.ImmSrc(ImmSrc),
		.ALUOp(ALUOp),
		.DataExtSrc(DataExtSrc),
	    .RegDataSrc(RegDataSrc)
	);
	aludec ad(
//		.opb5(op[5]),
		.funct3(funct3),
		.funct7b5(funct7b5),
		.ALUOp(ALUOp),
		.ALUControl(ALUControl)
	);
	
	dataExtDec dec(
	   .op(op),
	   .funct3(funct3),
	   .DataSrc(DataSrc)
	);
	
	// PCSrc -> 0 for jalr; 1 for branch (cond) or jal; 2 for regular PC+4
	assign PCSrc[0] = (Branch & BCond) | Jump;
	assign PCSrc[1] = (op[6] & (~op[3]) & op[2]) ? 0 : 1;
	
	// StoreSrc -> 0 for sw, 1 for sh, sb.
	assign StoreSrc = (MemWrite & funct3[1]) ? 0 : 1;
	
	
endmodule
