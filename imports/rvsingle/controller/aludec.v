module aludec (
	// opb54,  necessary?
	funct3,
	funct7b5,
	ALUOp,
	ALUControl
);
	// input wire [1:0] opb54;  necessary?
	input wire [2:0] funct3;
	input wire funct7b5;
	input wire [1:0] ALUOp;
	output reg [3:0] ALUControl;
//	wire RtypeSub;
//	assign RtypeSub = funct7b5 & opb54[1];
	
	always @(*)
		case (ALUOp)
			2'b00: ALUControl = 4'b0000;  // add (used for load and store)
			
			2'b01:                                       // branch inst.
			     case (funct3)
					3'b000: ALUControl = 4'b1001;   // equal condition
					3'b001: ALUControl = 4'b1010;   // not-equal condition
					3'b100: ALUControl = 4'b0101;   // signed less than condition
					3'b101: ALUControl = 4'b0111;   // signed greater or equal cond
					3'b110: ALUControl = 4'b0110;   // unsigned less than cond
					3'b111: ALUControl = 4'b1000;   // unsigned greater or equal cond
					default: ALUControl = 4'bxxxx;
				endcase
				
			2'b10:                       // R inst.
				case (funct3)
					3'b000:
						if (funct7b5)
							ALUControl = 4'b0001; // sub
						else
							ALUControl = 4'b0000; // add
					3'b001: ALUControl = 4'b1011;   // sll
					3'b010: ALUControl = 4'b0101;   // slt
					3'b011: ALUControl = 4'b0110;   // sltu
					3'b100: ALUControl = 4'b0100;   // xor
					3'b101: 
					   if(funct7b5)
					       ALUControl = 4'b1101;   // sra
					   else
                           ALUControl = 4'b1100;   // srl
					3'b110: ALUControl = 4'b0011;   // or
					3'b111: ALUControl = 4'b0010;   // and
					default: ALUControl = 4'bxxxx;
				endcase
			
			2'b11:           // arithmetic I inst.
			     case (funct3)
					3'b000: ALUControl = 4'b0000; // add
					3'b001: ALUControl = 4'b1011;   // sll
					3'b010: ALUControl = 4'b0101;   // slt
					3'b011: ALUControl = 4'b0110;   // sltu
					3'b100: ALUControl = 4'b0100;   // xor
					3'b101: 
					   if(funct7b5)
					       ALUControl = 4'b1101;   // sra
					   else
                           ALUControl = 4'b1100;   // srl
					3'b110: ALUControl = 4'b0011;   // or
					3'b111: ALUControl = 4'b0010;   // and
					default: ALUControl = 4'bxxxx;
				endcase
				
			default: ALUControl = 4'bxxxx;
		endcase
endmodule
