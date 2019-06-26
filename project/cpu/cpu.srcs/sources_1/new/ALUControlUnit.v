`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/10 12:43:45
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(
    input [5:0] funct,
    input [1:0] ALUOp,
    input [5:0] opcode,
    output reg [5:0] ALUControlCode
    );
    
    localparam ADD = 6'h20;
    localparam SUB = 6'h22;
    localparam SLT = 6'h2a;
    
    always @(ALUOp or funct or opcode)
    begin
        case(ALUOp)
            2'b00: ALUControlCode = ADD;
            2'b01: ALUControlCode = SUB;
            2'b10: ALUControlCode = funct[5:0];
            2'b11:
                begin
                    if(opcode == 6'ha) ALUControlCode = 6'h2a;
                    else ALUControlCode = opcode[5:0] + 6'h18;
                end
            default: ALUControlCode = ADD;
        endcase
    end
    
endmodule
