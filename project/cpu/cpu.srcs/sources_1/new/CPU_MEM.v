`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module CPU_MEM(
    input clk_2mhz,
    input cont,
    input run,
    input rst,
    input [31:0] addr_ddu,
    output [31:0] pc,mem_data_ddu,reg_data,io_data_ddu,
    input valid_frame,
    input [7:0] frame,
    output reg ready,
    output en_tx,
    output [63:0]buffer_TX,
    input start
    );
    
    wire clk_cpu, we,rst_int, rst_ready;
    wire [31:0] a_cpu,wd,mem_data_cpu,data_cpu;
    wire [31:0] io_data_cpu;
    reg [2:0] cnt;
    reg int;
    reg [63:0] buffer_RX;
    wire [31:0] R[3:0];
    wire [31:0] R_RX[1:0];
    reg [31:0] R_TX[1:0];

    wire overflow,real_we;
    wire [31:0] addr_io_byte,addr_io_word;

    MEM mo_mem(clk_cpu, rst, real_we, wd, a_cpu, addr_ddu, mem_data_cpu, mem_data_ddu);   
    CPU mo_cpu(clk_cpu, cont, run, int, rst, data_cpu, addr_ddu[6:2], a_cpu, we, wd, reg_data, pc, rst_int, rst_ready,en_tx,start);//

    assign clk_cpu = clk_2mhz;
    
    assign overflow = (a_cpu >= 32'h1000) ? 1:0;
    assign real_we = we & !overflow;
    
    assign addr_io_byte = a_cpu - 32'h1000;
    assign addr_io_word = addr_io_byte >> 2;
    
    
    assign io_data_cpu = R[addr_io_word];
    assign data_cpu = overflow ? io_data_cpu : mem_data_cpu;
  
    assign buffer_TX[31:0] = R_TX[0];
    assign buffer_TX[63:32] = R_TX[1];
    assign R_RX[0] = buffer_RX[31:0]; 
    assign R_RX[1] = buffer_RX[63:32];
    
    assign R[0] = R_RX[0];
    assign R[1] = R_RX[1];
    assign R[2] = R_TX[0];
    assign R[3] = R_TX[1];
    assign io_data_ddu = R[addr_ddu[31:2]];

    always @(posedge clk_cpu)
    begin
        if(we && overflow) R_TX[addr_io_word - 2] = wd;
    end
  
    
    always@(posedge valid_frame or posedge rst_int or posedge rst_ready or posedge rst)
    begin
        if(rst_int || rst)
        begin
            cnt = 0;
            int = 0;
            ready = 0;
        end
        else if(rst_ready)
        begin
            ready = 0;
            cnt = 0;
        end
        else if(!ready && valid_frame)
        begin
            //buffer_RX = buffer_RX >> 8;
            //buffer_RX[63:56] = frame;
            buffer_RX = buffer_RX << 8;
            buffer_RX[7:0] = frame;  
            cnt = cnt + 1;
            if(cnt == 0) 
            begin
                ready = 1;
                int = 1;
            end
        end
    end
    
endmodule
