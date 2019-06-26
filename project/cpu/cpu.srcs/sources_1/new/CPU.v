`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 20:37:42
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clk,
    input cont,
    input run,
    input int,
    input rst,
    input [31:0] MemData,
    input [4:0] RegNum,
    output [31:0] MemAddr,
    output MemWrite_out,
    output [31:0] MemWriteData,
    output [31:0] RegData,
    output [31:0] PC_out,
    output rst_int, rst_ready,en_tx,
    input start
    );
    
    wire [5:0] opcode;
    wire [1:0] ALUSrcB,ALUOp,PCSource;                                              
    wire INTPCSource,ALUSrcA,IorD,IRWrite,PCWrite,PCWriteCond,MemWrite,RegDst,RegWrite,MemtoReg,PCWriteCond_bne,EPCWrite,CauseWrite;
    wire enable_int;
    wire real_PCWrite;
    
    
    //some registers
    reg [31:0] PC, EPC;
    reg [31:0] ALUOut;
    reg [31:0] A,B;
    reg [31:0] MDR;
    reg [31:0] IR;
    
    //ALU port 
    wire Zero;
    wire [31:0] ALUResult;
    wire [5:0] ALUControlCode;
    
    //Register port
    //wire [4:0] RegReadNum1,RegReadNum2;
    wire [31:0] RegReadData1, RegReadData2;
    
    //some muxes
    wire [31:0] Mux_MemAddr, Mux_RegWriteData, Mux_ALU_A,Mux_INT_PC;
    reg [31:0] Mux_ALU_B, Mux_PC;
    wire [4:0]  Mux_RegWriteNum;
    
    //Instruction extend
    wire [31:0] Ins_16Signed32, Ins_16Signed32_noSL, Ins_16Signed32_SL;
    wire [15:0] sign;
    wire [27:0] Ins_26to28;
    wire [31:0] JumpAddr;
    
    localparam INTTable = 32'h00000040;
    
    Reg_File mo_reg_file(IR[25:21], IR[20:16], RegNum, Mux_RegWriteNum, Mux_RegWriteData, RegWrite, rst, clk, RegReadData1, RegReadData2, RegData); 
    ALUControlUnit mo_alucu(IR[5:0], ALUOp , opcode, ALUControlCode);
    ALU mo_alu(Mux_ALU_A, Mux_ALU_B, ALUControlCode, ALUResult, Zero); 
    ControlUnit mo_control_unit(clk,cont,run,int,enable_int,rst,opcode,rst_int,rst_ready,en_tx,start,ALUSrcB,ALUOp,PCSource,INTPCSource,ALUSrcA,IorD,IRWrite,PCWrite,PCWriteCond,MemWrite,RegDst,RegWrite,MemtoReg,PCWriteCond_bne,EPCWrite, CauseWrite);
    assign opcode = IR[31:26];
    //output
    assign MemAddr = Mux_MemAddr;
    assign MemWriteData = B;
    assign MemWrite_out = MemWrite;
    assign PC_out = PC;
    
    //singal 
    assign real_PCWrite = PCWrite | (PCWriteCond & Zero) | (PCWriteCond_bne & ~Zero);
    assign enable_int = 1'b1;
    
    //Instruction extend
    assign sign = IR[15] ? 16'hffff : 16'h0000;
    assign Ins_16Signed32 = {sign, IR[15:0]};
    assign Ins_16Signed32_noSL = Ins_16Signed32;
    assign Ins_16Signed32_SL = Ins_16Signed32 << 2;
    assign Ins_26to28 = {IR[25:0], 2'b00};
    assign JumpAddr = {PC[31:28], Ins_26to28};

    //MUX
    assign Mux_MemAddr = IorD ? ALUOut : PC;
    assign Mux_RegWriteData = MemtoReg ? MDR : ALUOut;
    assign Mux_RegWriteNum = RegDst ? IR[15:11] : IR[20:16];
    assign Mux_ALU_A = ALUSrcA ? A : PC;
    assign Mux_INT_PC = INTPCSource ? INTTable : EPC;
    
    //PC
    always @(posedge clk or posedge rst)
    begin
        if(rst) PC <= 32'h00000000;
        else 
        begin
            if(real_PCWrite) PC <= Mux_PC;
        end
    end
    
    //EPC
    always @(posedge clk)  
    begin                                                             
        //if(EPCWrite) EPC <= ALUResult;
        if(EPCWrite) EPC <= PC;           //      
    end                                   
    
    //MDR
    always @(posedge clk)
    begin
        MDR <= MemData;
        A <= RegReadData1;
        B <= RegReadData2;
        ALUOut <= ALUResult;
    end
    
    //IR
    always @(posedge clk)
    begin
        if(IRWrite) IR <= MemData;
    end
    
    //Mux_ALU_B 4-way
    always @(ALUSrcB or B or Ins_16Signed32_noSL or Ins_16Signed32_SL)
    begin
        case(ALUSrcB)
            2'b00: Mux_ALU_B = B;
            2'b01: Mux_ALU_B = 32'd4;
            2'b10: Mux_ALU_B = Ins_16Signed32_noSL;
            2'b11: Mux_ALU_B = Ins_16Signed32_SL;
            default: Mux_ALU_B = B;
        endcase
    end 
    
    //Mux_PC 3-way
    always @(PCSource or ALUResult or ALUOut or JumpAddr or Mux_INT_PC)
    begin
        case(PCSource)
            2'b00: Mux_PC = ALUResult;
            2'b01: Mux_PC = ALUOut;
            2'b10: Mux_PC = JumpAddr;
            2'b11: Mux_PC = Mux_INT_PC; //ÖÐ¶Ï´¦Àí
            default: Mux_PC = ALUResult;
        endcase
    end
     
endmodule
