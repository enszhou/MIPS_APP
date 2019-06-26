`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 18:37:04
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a,
    input [31:0] b,
    input [5:0] ALUControlCode,
    output reg [31:0] result,
    output wire Zero
    );

    localparam ADD = 6'h20;
    localparam SUB = 6'h22;
    localparam AND = 6'h24;
    localparam  OR = 6'h25;
    localparam NOR = 6'h27;
    localparam XOR = 6'h26;
    localparam SLT = 6'h2a;
    localparam SRLV = 6'h6;
    localparam SLLV = 6'h4;

    wire [31:0] slt, c;
    assign Zero = ~(|result);
    assign c = a + ~b + 1;
    assign slt = c[31] ? 32'b1 : 32'b0;
    
    always @(*)
    begin  
        case(ALUControlCode)
           ADD: result = a + b;
           SUB: result = a - b;
           AND: result = a & b;                    
           OR : result = a | b;           
           NOR: result = ~(a | b);                  
           XOR: result = a ^ b;  
           SLT: result = slt;
           SRLV : result = b >> a[4:0];    
           SLLV : result = b << a[4:0];           
           default: result = 32'b1;
       endcase 
    end
endmodule
