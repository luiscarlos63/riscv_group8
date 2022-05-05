module immExtend (
	instr,
	immsrc,
	funct3,
	opb4,
	immext
);
	input wire [31:7] instr;
	input wire [2:0] immsrc;
	
	// aditional inputs
	input wire [2:0] funct3;
	input wire opb4;
	
	output reg [31:0] immext;
	always @(*)
		case (immsrc)
			3'b000:       // I type
			     if((funct3 == 3'b001 || funct3 == 3'b101) && opb4)
			         immext = {{27 {1'b0}}, instr[24:20]};      // slli, srli, srai
			     else
			         immext = {{20 {instr[31]}}, instr[31:20]};      // other I inst.
			     
			3'b001: immext = {{20 {instr[31]}}, instr[31:25], instr[11:7]};   // S type
			3'b010: immext = {{20 {instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};   // B type
			3'b011: immext = {{12 {instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; // J type
			3'b100: immext = {instr[31:12], {12 {1'b0}}};     // U type
			
			default: immext = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
endmodule
