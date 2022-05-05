`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 06:46:31 PM
// Design Name: 
// Module Name: data_extend
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


module dataExtend(
        DataSrc,
        dataIn,
        dataext
    );
    
    input wire [2:0] DataSrc;
	input wire [31:0] dataIn;
	output reg [31:0] dataext;
	
	always @(*)
		case (DataSrc)
			3'b000: dataext = dataIn;    // bypass
			3'b001: dataext = {{24 {dataIn[7]}}, dataIn[7:0]};   // signed byte
			3'b010: dataext = {{16 {dataIn[15]}}, dataIn[15:0]};   // signed half
			3'b011: dataext = {{24 {1'b0}}, dataIn[7:0]};   // unsigned byte
			3'b100: dataext = {{16 {1'b0}}, dataIn[15:0]};   // unsigned half
			
			default: dataext = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
    
endmodule
