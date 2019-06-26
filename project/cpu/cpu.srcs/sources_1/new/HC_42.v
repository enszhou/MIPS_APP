`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2019/05/27 19:23:21
//////////////////////////////////////////////////////////////////////////////////
module HC_42(
    input clk_9600hz,
    input clk_153600hz,
    input RX,
    input en_tx,
    input [63:0] buffer_TX,
    output reg TX,
    output start,
    output reg flag,
    output reg [7:0] frame
    );
    reg receiving,traning,gap;
    reg [3:0] b;
    reg [7:0] n;
    reg [2:0] cyc_tx;
    reg [5:0] low;
    reg cnt;
    wire [31:0] data;
    reg [2:0] c;
    reg continue;
    reg[3:0] cyc;
     
     assign start = traning;
     
     always@(posedge clk_153600hz)
     begin
        if(RX == 1'b0 && continue == 1'b0 && !receiving) 
        begin
            continue = 1;
            c = 1;
        end
        else if(continue)
        begin
            if(RX == 0) c = c + 1;
            else continue = 0;
            if(c == 0)
            begin
                receiving = 1;
                continue = 0;
                cyc = 1;
                b = 0;
            end
        end
        else if(receiving == 1 && cyc==0 )           
        begin  
          if(b==4'b1000) receiving = 0;
          cyc = cyc + 1; 
          n[b] = RX;
          b = b + 1;             
          if(b == 4'b1000)               
          begin                             
              flag = 1;        
              frame = n;
          end                                  
        end
        else 
        begin
            flag = 0; 
            cyc = cyc + 1;
        end  
     end
     //axi_uartlite_0 mo_axi(.rx(RX),.s_axi_aclk(clk_48mhz),.s_axi_araddr(4'b0), .s_axi_rdata(data),.s_axi_aresetn(rstn),.interrupt(ipt));
     
     /*always @(posedge clk_9600hz)
     begin
        if(receiving == 0 && RX == 0)  
        begin
            flag = 0;                          
            receiving = 1;                
            b = 0;    
            rstn = 1;                 
        end                            
        else if(receiving == 1)           
        begin   
          n[b] = RX;
          b = b + 1;             
          if(b == 3'b0)               
          begin                             
              receiving = 0;
              flag = 1;        
              frame = data[7:0];
              rstn = 0;
          end                                  
        end
        else
        begin
            flag = 0;   
            rstn = 1;
        end
     end*/
     
     /*always @(posedge clk_9600hz)
     begin
        if(receiving == 0 && RX == 0)  
        begin
            flag = 0;                          
            receiving = 1;                
            b = 0;                     
        end                            
        else if(receiving == 1)           
        begin   
          n[b] = RX;
          b = b + 1;             
          if(b == 3'b0)               
          begin                             
              receiving = 0;
              flag = 1;        
              frame = n;
          end                                  
        end
        else flag <= 0;   
     end*/
     
     always@(posedge clk_9600hz)
     begin
        if(en_tx && !traning)
        begin
            low = 6'd0;
            cyc_tx = 0;
            traning = 1;
            cnt = 0;
            gap = 1'b1;
        end
        else if(traning && gap)
        begin
            if(cnt == 2'b1)
            begin
                TX = 0;
                gap = 0;
                low = low - 6'd8;
            end
            else TX = 1;
            cnt = cnt + 1'b1;
        end
        else if(traning)
        begin
            TX = buffer_TX[low + cyc_tx];
            cyc_tx = cyc_tx + 1;
            if(cyc_tx == 3'b0) gap = 1'b1;
            if(low == 6'b0 && cyc_tx == 3'b0)
            begin
                traning = 0;
            end
        end
        else 
        begin
            TX = 1;
        end
     end
endmodule
