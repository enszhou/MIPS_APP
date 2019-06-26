`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 21:49:42
// Design Name: 
// Module Name: MUX_2
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


module MUX_2 #(parameter WIDTH=32)(
    input sel,
    input p0,
    input p1,
    output d
    );
    
    assign d = sel ? p1 : p0;
endmodule
