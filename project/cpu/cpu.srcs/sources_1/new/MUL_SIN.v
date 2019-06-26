`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 23:02:54
// Design Name: 
// Module Name: MUL_SIN
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


module MUL_SIN(
    input clk,
    input s,
    input rst,
    output reg q
    );
    reg last;
 
    always @(negedge clk or posedge rst)
    begin
        if(rst)
        begin
            last <= 0;
        end
        else
        begin
            if(!last && s) 
            begin
                q <= 1'b1;
                last <= 1'b1; 
            end
            else if(last && s) q <= 1'b0;
            else if(last && !s)
            begin
                q <= 1'b0;
                last <= 1'b0;
            end
            else q <= 1'b0;
        end
    end
endmodule
