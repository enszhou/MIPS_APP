`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/10 22:15:11
// Design Name: 
// Module Name: CPU_MEM_tb
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


module CPU_MEM_tb(

    );
    
    reg clk, rst, mode_cpu,cont,run,v;
    wire [31:0] mem_data, reg_data, pc;
    reg [31:0]addr;
    reg [7:0] frame;
    
    CPU_MEM mo_cpu_mem_tb(clk,cont, run, rst, addr, pc, mem_data,reg_data,v,frame);
    
    
    initial
    begin
        v <= 0;
        frame <=8'b01010101;
        clk <= 0;
        run <= 1;
        rst <= 0;
        cont <= 1;
        addr <= 32'h8;
        #10 rst <= 1;
        #4 rst <= 0;
        #500 mode_cpu <= 0;
        #400 addr <= 32'h4;
    end
    
    
    always
    forever #1 clk = ~clk;
    
    /*always
    begin
    #16;
    forever #2 run = ~run;
    end*/
    
    always 
    forever #25 v <= ~v;
    
endmodule
