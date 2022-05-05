`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 07:26:41 PM
// Design Name: 
// Module Name: dataextdec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataExtDec(
        op,
        funct3,
        DataSrc
    );
    
    input wire [6:0] op;
	input wire [2:0] funct3;
	output reg [2:0] DataSrc;
	
	always @(*) begin
	   if (op == 7'b0000011 || op == 7'b0100011) begin
	       case (funct3)
	           3'b000: DataSrc = 3'b001;   // byte
	           3'b001: DataSrc = 3'b010;   // half
	           3'b010: DataSrc = 3'b000;   // word (bypass)
	           3'b100: DataSrc = 3'b011;   // byte unsigned
	           3'b101: DataSrc = 3'b100;   // half unsigned
	           default: DataSrc = 3'bxxx;
	       endcase
	   end
	   else DataSrc = 3'b000;   // word (bypass) (for other instructions)
	end
endmodule
