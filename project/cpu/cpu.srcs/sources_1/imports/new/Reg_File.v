`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/06 22:55:39
// Design Name: 
// Module Name: Reg_File
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


module Reg_File (
    input [4:0]ra0, 
    input [4:0]ra1, 
    input [4:0]ra2,
    input [4:0]wa,  
    input [31:0]wd,  
    input we, 
    input rst,
    input clk, 
    output [31:0]rd0,
    output [31:0]rd1,
    output [31:0]rd2
    );
    
    reg [31:0]R[31:0];
    reg [4:0] addr;
    
    assign rd0 = R[ra0];
    assign rd1 = R[ra1];
    assign rd2 = R[ra2];
    
    always @(posedge clk or posedge rst)
    begin
        if(rst) R[0] = 32'b0;
        else if(we)
        begin
            addr = wa;
            R[addr] = wd;
            if(addr==0) R[0] = 32'b0;
        end
    end
    
endmodule
