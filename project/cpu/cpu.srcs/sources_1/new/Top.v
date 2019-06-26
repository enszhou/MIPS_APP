`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 21:42:24
// Design Name: 
// Module Name: Top
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


module Top(
    input cont,            
    input step,            
    input [2:0] mode_seg,     
    input inc,             
    input dec,             
    input rst,             
    input CLK100MHZ,
    input RX,
    output TX,  
    output mode_kernel,
    output mode_user,
    output tag_frame,         
    output [15:0] led,     
    output [6:0]seg,
    output [7:0]an,
    output dp  
    );
    wire clk_8mhz,clk_cpu,clk_2mhz,clk_9600hz,clk_9600khz,clk_153600hz,clk_19_2mhz;
    wire run;
    wire [31:0] pc,mem_data,reg_data,addr,io_data;
    wire [15:0] display;
    wire [7:0] frame;
    wire [1:0] mode;
    wire valid_frame, ready,en_tx,start;
    wire [63:0] buffer;
    
    assign dp = display[15];
    assign seg = display[14:8];
    assign an = display[7:0];
    assign {mode_kernel, mode_user} = mode;
    assign tag_frame = valid_frame | ready;
    
    //assign clk_cpu = clk_2mhz & run;
    
    clk_wiz_0 mo_clk_wiz_0(clk_8mhz,clk_19_2mhz, CLK100MHZ);
    CLK #(4) mo_clk_2m(clk_8mhz,0,1,clk_2mhz);
    CLK #(2000) mo_clk_9600(clk_19_2mhz,0,1,clk_9600hz);
    CLK #(125) mo_clk_153600(clk_19_2mhz,0,1,clk_153600hz);
    
    DDU mo_ddu(cont,step,mode_seg,inc,dec,pc,mem_data,reg_data,frame, valid_frame, io_data, rst,clk_8mhz,clk_2mhz,run,addr,led,display,mode);
    CPU_MEM mo_cpu_mem(clk_2mhz,cont, run, rst, addr, pc, mem_data,reg_data, io_data, valid_frame, frame, ready,en_tx,buffer,start);
    HC_42 mo_hc_42(clk_9600hz,clk_153600hz,RX,en_tx,buffer,TX,start,valid_frame,frame);
    
    //MEM mo_mem(clk_cpu,rst,mode_cpu,we,ra_cpu,wd,ra_cpu,addr,mem_data);
    //CPU mo_cpu(clk_cpu, rst, mem_data, addr[6:2], ra_cpu, we,wd,reg_data);
endmodule
