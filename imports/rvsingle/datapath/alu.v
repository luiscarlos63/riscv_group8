module alu (
	SrcA,
	SrcB,
	ALUControl,
	ALUResult,
	BCond
);
	input wire [31:0] SrcA;
	input wire [31:0] SrcB;
	input wire [3:0] ALUControl;
	output reg [31:0] ALUResult;
	output wire BCond;
	
	wire signed [31:0] SigSrcA;
	wire signed [31:0] SigSrcB;
	assign SigSrcA = SrcA;
	assign SigSrcB = SrcB;
	
	assign BCond = ALUResult == 32'b00000000000000000000000000000001;
	always @(*)
		case (ALUControl)
			4'b0000: ALUResult = SrcA + SrcB;
			4'b0001: ALUResult = SrcA - SrcB;
			4'b0010: ALUResult = SrcA & SrcB;
			4'b0011: ALUResult = SrcA | SrcB;
			4'b0100: ALUResult = SrcA ^ SrcB;                // xor
			4'b0101: ALUResult = SigSrcA < SigSrcB;      // signed slt
			4'b0110: ALUResult = SrcA < SrcB;                // unsigned slt
			4'b0111: ALUResult = SigSrcA >= SigSrcB;   // signed greater or equal
			4'b1000: ALUResult = SrcA >= SrcB;             // unsigned greater or equal
			4'b1001: ALUResult = SrcA == SrcB;             // equal condition
			4'b1010: ALUResult = SrcA != SrcB;              // not-equal condition
			4'b1011: ALUResult = SrcA << SrcB[4:0];     // shift left logic
			4'b1100: ALUResult = SrcA >> SrcB[4:0];     // shift right logic
			4'b1101: ALUResult = SrcA >>> SrcB[4:0];  // shift right arithmetic
			default: ALUResult = ALUResult;
		endcase
endmodule
