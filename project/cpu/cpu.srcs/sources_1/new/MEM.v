`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 20:39:19
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk,
    input rst,
    input we, //cpu使能
    input [31:0]wd, //cpu写数据
    input [31:0]a_cpu, //cpu 地址
    input [31:0]ra_ddu, //ddu读地址
    output [31:0]rd_cpu, 
    output [31:0]rd_ddu
    );
    
    //assign addr = ra[9:2];
    //assign mode_we = we & mode_cpu;
    
    dist_mem_gen_0   mo_dist_mem ( //256*32
  .a(a_cpu[31:2]),        	// input wire [9 : 0] a
  .d(wd),        	// input wire [31 : 0] d
  .dpra(ra_ddu[31:2]),  	// input wire [9 : 0] dpra
  .clk(clk),    	// input wire clk
  .we(we),      	// input wire we
  .spo(rd_cpu),
  .dpo(rd_ddu)    	// output wire [31 : 0] dpo
);
    
    /*always @(ra_cpu or ra_ddu or mode_cpu)
    begin
        if(mode_cpu) ra = ra_cpu;
        else ra = ra_ddu;
    end*/
       
endmodule
















