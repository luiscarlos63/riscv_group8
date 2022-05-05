module maindec (
	op,
	ResultSrc,
	MemWrite,
	Branch,
	ALUSrc,
	RegWrite,
	Jump,
	ImmSrc,
	ALUOp,
	//StoreSrc,
	DataExtSrc,
	RegDataSrc
	//DataExt
);
	input wire [6:0] op;
	output wire [1:0] ResultSrc;
	output wire MemWrite;
	output wire Branch;
	output wire ALUSrc;
	output wire RegWrite;
	output wire Jump;
	output wire [2:0] ImmSrc;
	output wire [1:0] ALUOp;
	
	// aditional signals
	//output wire StoreSrc;  // used to select whole 32bit register word (0) or half / byte (1) for store inst. (INT)
	output wire DataExtSrc;    // used to select data extender block source (0 for store inst. 1 for load inst.)
	output wire [1:0] RegDataSrc;    // select Reg file write source (0: load; 1: auipc; 2: lui)
	//output wire [2:0] DataExt;     // select data extender mode (INT)
	
	reg [15:0] controls;
	// 15 bit control word
	assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, DataExtSrc, RegDataSrc} = controls;
	always @(*)
		case (op)
			7'b0000011: controls = 15'b1_000_1_0_01_0_00_0_1_00;  // load
			7'b0100011: controls = 15'b0_001_1_1_00_0_00_0_0_xx;  // store
			7'b0110011: controls = 15'b1_xxx_0_0_00_0_10_0_x_00;  // arithmetic
			7'b1100011: controls = 15'b0_010_0_0_xx_1_01_0_x_xx;  // branch
			7'b0010011: controls = 15'b1_000_1_0_00_0_11_0_x_00;  // arithmetic (immediate)
			7'b1101111: controls = 15'b1_011_x_0_10_0_xx_1_x_00;  // jump and load
			default: controls = 15'bxxxxxxxxxxxxxx;
		endcase
endmodule
