`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 22:19:47
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input clk,
    input cont,
    input run,
    input int,
    input enable_int,
    input rst,
    input [5:0] opcode,
    output reg rst_int,rst_ready,en_tx,
    input start,
    output reg [1:0] ALUSrcB,ALUOp,PCSource,
    output reg INTPCSource,ALUSrcA,IorD,IRWrite,PCWrite,PCWriteCond,MemWrite,RegDst,RegWrite,MemtoReg,PCWriteCond_bne,EPCWrite,CauseWrite
    );
    
    localparam CONT = 5'b00000;
    localparam STEP = 5'b01111;
    localparam INT = 5'b01101;
    
    wire [3:0] init,end_next;
    wire real_int;
    
    assign real_int = int & enable_int;
    assign init = cont ? CONT : STEP;
    assign end_next = real_int ? INT : init;
    
    reg [3:0] state, nextstate;
    reg flag;
    //reg [1:0] ALUSrcB,ALUOp,PCSource;
    //reg ALUSrcA,IorD,IRWrite,PCWrite,PCWriteCond,MemWrite,RegDst,RegWrite,MemtoReg;
    
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= init;
        end
        else
        begin
            state <= nextstate;
        end
    end
    
    always@(state or opcode or run or end_next or init)
    begin
        case(state)
            5'b00000:nextstate = 5'b00001;
            5'b00001:
                begin
                    if(opcode == 6'h23 || opcode == 6'h2b) nextstate = 5'b00010;
                    else if(opcode == 6'h4)nextstate = 5'b01000;
                    else if(opcode == 6'h2)nextstate = 5'b01001;
                    else if(opcode == 6'h5)nextstate = 5'b01010;
                    else if(opcode == 6'h0)nextstate = 5'b00110; //RR
                    else if(opcode == 6'h10)nextstate = 5'b01110;
                    else nextstate = 5'b01011; //RI
                end
            5'b00010:
                begin
                    if(opcode == 6'h23) nextstate = 5'b00011;
                    else nextstate = 5'b00101;
                end
            5'b00011: nextstate = 5'b00100;
            5'b00100: nextstate = end_next;
            5'b00101: nextstate = end_next;
            5'b00110: nextstate = 5'b00111;
            5'b00111: nextstate = end_next;
            5'b01000: nextstate = end_next;
            5'b01001: nextstate = end_next;
            5'b01010: nextstate = end_next;
            5'b01011: nextstate = 5'b01100; //compute
            5'b01100: nextstate = end_next; //reg write
            5'b01101: nextstate = init; //ÖÐ¶Ï
            5'b01110: nextstate = init; //eret
            5'b01111: if(run) nextstate = 5'b00000;
                     else nextstate = 5'b01111;
            default: nextstate = init;
        endcase
        
    end
    
    always @(posedge clk or posedge rst)
    begin
    //if(clk)begin
        if(rst)
        begin
            ALUSrcA  <= 1'b0;   
            ALUSrcB  <= 2'b01;  
            ALUOp    <= 2'b00;  
            IorD     <= 1'b0;   
            PCSource <= 2'b00;  
            IRWrite  <= cont;   
            MemWrite <= 1'b0;   
            RegWrite <= 1'b0;   
            PCWrite  <= cont;   
            PCWriteCond <= 1'b0;
            PCWriteCond_bne <= 1'b0;
            EPCWrite <= 1'b0;  
            CauseWrite <= 1'b0;
            rst_int <= 1'b0;
            rst_ready <= 1'b0;
        end
        else
        begin
        case(nextstate)
            5'b00000:
                begin
                    ALUSrcA  <= 1'b0;
                    ALUSrcB  <= 2'b01;
                    ALUOp    <= 2'b00;
                    IorD     <= 1'b0;
                    PCSource <= 2'b00;
                    IRWrite  <= 1'b1;
                    MemWrite <= 1'b0;
                    RegWrite <= 1'b0;
                    PCWrite  <= 1'b1;
                    PCWriteCond <= 1'b0;
                    PCWriteCond_bne <= 1'b0;
                    EPCWrite <= 1'b0;  
                    CauseWrite <= 1'b0;
                    rst_int <= 1'b0;
                    rst_ready <= 1'b0;
                end
            5'b00001:
                begin
                    ALUSrcA  <= 1'b0; 
                    ALUSrcB  <= 2'b11;
                    ALUOp    <= 2'b00;
                    IRWrite  <= 1'b0;   
                    MemWrite <= 1'b0;   
                    RegWrite <= 1'b0;   
                    PCWrite  <= 1'b0;   
                    PCWriteCond <= 1'b0; 
                    PCWriteCond_bne <= 1'b0; 
                    EPCWrite <= 1'b0;  
                    CauseWrite <= 1'b0;                       
                end
            5'b00010:
              begin
                  ALUSrcA  <= 1'b1; 
                  ALUSrcB  <= 2'b10;
                  ALUOp    <= 2'b00;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b0;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0;
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                         
              end
            5'b00011:
              begin
                  IorD <= 1'b1;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b0;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0;
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                         
              end
            5'b00100:
              begin
                  RegDst <= 1'b0;
                  MemtoReg <= 1'b1;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b1;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0;
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                         
              end
            5'b00101:
              begin
                  IorD <= 1'b1;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b1;   
                  RegWrite <= 1'b0;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0; 
                  PCWriteCond_bne <= 1'b0; 
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                       
              end
            5'b00110:
              begin
                  ALUSrcA  <= 1'b1; 
                  ALUSrcB  <= 2'b00;
                  ALUOp    <= 2'b10;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b0;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0;   
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                      
              end
            5'b00111:
              begin
                  RegDst <= 1'b1;
                  MemtoReg <= 1'b0;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b1;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b0; 
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                        
              end
            5'b01000:
              begin
                  ALUSrcA  <= 1'b1; 
                  ALUSrcB  <= 2'b00;
                  ALUOp    <= 2'b01;
                  PCSource <= 2'b01;
                  IRWrite  <= 1'b0;   
                  MemWrite <= 1'b0;   
                  RegWrite <= 1'b0;   
                  PCWrite  <= 1'b0;   
                  PCWriteCond <= 1'b1;
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;                         
              end
            5'b01001:                 
              begin                  
                  PCSource <= 2'b10; 
                  IRWrite  <= 1'b0;  
                  MemWrite <= 1'b0;  
                  RegWrite <= 1'b0;  
                  PCWrite  <= 1'b1;  
                  PCWriteCond <= 1'b0;
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;
              end 
            5'b01010:                      
              begin                       
                  ALUSrcA  <= 1'b1;       
                  ALUSrcB  <= 2'b00;      
                  ALUOp    <= 2'b01;      
                  PCSource <= 2'b01;      
                  IRWrite  <= 1'b0;       
                  MemWrite <= 1'b0;       
                  RegWrite <= 1'b0;       
                  PCWrite  <= 1'b0;       
                  PCWriteCond <= 1'b0;    
                  PCWriteCond_bne <= 1'b1;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;
              end                         
            5'b01011:                      
              begin                       
                  ALUSrcA  <= 1'b1;       
                  ALUSrcB  <= 2'b10;      
                  ALUOp    <= 2'b11;           
                  IRWrite  <= 1'b0;       
                  MemWrite <= 1'b0;       
                  RegWrite <= 1'b0;       
                  PCWrite  <= 1'b0;       
                  PCWriteCond <= 1'b0;    
                  PCWriteCond_bne <= 1'b0;
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0;
              end                         
            5'b01100:                        
              begin                         
                  RegDst <= 1'b0;
                  MemtoReg <= 1'b0;       
                  IRWrite  <= 1'b0;         
                  MemWrite <= 1'b0;         
                  RegWrite <= 1'b1;         
                  PCWrite  <= 1'b0;         
                  PCWriteCond <= 1'b0;      
                  PCWriteCond_bne <= 1'b0; 
                  EPCWrite <= 1'b0;  
                  CauseWrite <= 1'b0; 
              end 
            5'b01101:           //ÖÐ¶Ï               
                begin
                    ALUSrcA <= 1'b0;
                    ALUSrcB <= 2'b01;
                    ALUOp <= 2'b00; //add   
                    INTPCSource <= 1'b1;   
                    PCSource <= 2'b11;                   
                    IRWrite  <= 1'b0;         
                    MemWrite <= 1'b0;         
                    RegWrite <= 1'b0;         
                    PCWrite  <= 1'b1;         
                    PCWriteCond <= 1'b0;      
                    PCWriteCond_bne <= 1'b0;
                    EPCWrite <= 1'b1;
                    CauseWrite <= 1'b1;  
                    rst_int <= 1'b1;
                end   
            5'b01110: //eret
                begin
                    INTPCSource <= 1'b0;
                    PCSource <= 2'b11;
                    IRWrite  <= 1'b0;       
                    MemWrite <= 1'b0;       
                    RegWrite <= 1'b0;       
                    PCWrite  <= 1'b1;       
                    PCWriteCond <= 1'b0;    
                    PCWriteCond_bne <= 1'b0;
                    EPCWrite <= 1'b0;       
                    CauseWrite <= 1'b0;
                    rst_ready <= 1'b1;   
                end                                                   
            5'b01111:
                begin                       
                    IRWrite  <= 1'b0;       
                    MemWrite <= 1'b0;       
                    RegWrite <= 1'b0;       
                    PCWrite  <= 1'b0;       
                    PCWriteCond <= 1'b0;    
                    PCWriteCond_bne <= 1'b0;
                    EPCWrite <= 1'b0;  
                    CauseWrite <= 1'b0;
                    rst_int <= 1'b0;
                    rst_ready <= 1'b0;
                end                                                                                                                                                                    
            default:
                begin
                    IRWrite  <= 1'b0;   
                    MemWrite <= 1'b0;   
                    RegWrite <= 1'b0;   
                    PCWrite  <= 1'b0;   
                    PCWriteCond <= 1'b0;
                    PCWriteCond_bne <= 1'b0;
                    EPCWrite <= 1'b0;  
                    CauseWrite <= 1'b0;
                    rst_int <= 1'b0;
                    rst_ready <= 1'b0;
                end                                  
        endcase
        end
    
    end
    
    always @(posedge clk or posedge rst or posedge start)
    begin
        if(rst || start) en_tx = 0;
        else if(nextstate == 5'b01110)
        begin
            en_tx = 1;
        end
    end
    
endmodule
