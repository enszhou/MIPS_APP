`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 21:41:54
// Design Name: 
// Module Name: DDU
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


module DDU(
    input cont,
    input step,
    input [2:0] mode_seg,
    input inc,
    input dec,
    input [31:0] pc,
    input [31:0] mem_data,
    input [31:0] reg_data,
    input [7:0]frame,
    input valid_frame,
    input [31:0] io_data,
    input rst,
    input clk_8mhz,
    input clk_cpu,
    output reg run,
    output reg [31:0] addr,
    output [15:0] led,
    output [15:0] display,
    output [1:0] mode
    );
    
    wire [6:0]seg;
    wire [7:0]AN;
    wire DP;
    wire clk_4khz,inc_sin,dec_sin,step_sin;
    reg [3:0] x0,x1,x2,x3,x4,x5,x6,x7;
    
   
    assign display = {DP,seg,AN};
    assign led[7:0] = pc[10:2];
    assign led[15:8] = addr[10:2];
    assign mode = (pc >= 32'h00000040) ? 2'b01 : 2'b10;
    
    CLK #(2000) mo_clk_4k(clk_8mhz,0,1,clk_4khz);
    SEG mo_seg(clk_4khz,8'b11111111,8'b00000000,x0,x1,x2,x3,x4,x5,x6,x7,AN,DP,seg);
    MUL_SIN mo_mul_sin_inc(clk_cpu,inc,rst,inc_sin);
    MUL_SIN mo_mul_sin_dec(clk_cpu,dec,rst,dec_sin);
    MUL_SIN mo_mul_sin_step(clk_cpu,step,rst,step_sin);         
  
    always@(mode_seg or mem_data or reg_data or frame)
    begin
        if(mode_seg == 3'b1)
        begin
            x0 = mem_data[3:0];
            x1 = mem_data[7:4];
            x2 = mem_data[11:8];
            x3 = mem_data[15:12];
            x4 = mem_data[19:16];
            x5 = mem_data[23:20];
            x6 = mem_data[27:24];
            x7 = mem_data[31:28];
        end
        else if(mode_seg == 3'b0)
        begin
            x0 = reg_data[3:0];  
            x1 = reg_data[7:4];  
            x2 = reg_data[11:8]; 
            x3 = reg_data[15:12];
            x4 = reg_data[19:16];
            x5 = reg_data[23:20];
            x6 = reg_data[27:24];
            x7 = reg_data[31:28];
        end
        else if(mode_seg == 3'b10)
        begin                     
            x0 = frame[0]; 
            x1 = frame[1]; 
            x2 = frame[2]; 
            x3 = frame[3]; 
            x4 = frame[4]; 
            x5 = frame[5]; 
            x6 = frame[6]; 
            x7 = frame[7]; 
        end   
        else
        begin
           x0 = io_data[3:0];  
           x1 = io_data[7:4];  
           x2 = io_data[11:8]; 
           x3 = io_data[15:12];
           x4 = io_data[19:16];
           x5 = io_data[23:20];
           x6 = io_data[27:24];
           x7 = io_data[31:28];
        end                                       
    end
    
    always@(posedge clk_cpu or posedge rst)
    begin
        if(rst)
        begin
            addr <= 32'b0;
        end
        else
        begin
            if(inc_sin) addr <= addr + 4;
            else if(dec_sin) addr <= addr - 4;
        end
    end
    
    always@(cont or clk_cpu or step_sin)
    begin
        if(cont) run = 1'b1;
        else run = step_sin;
    end
    
endmodule
