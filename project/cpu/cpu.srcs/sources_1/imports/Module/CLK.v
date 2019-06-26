`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// f = X/N
//CLK #(4) mo_clk_2m(clk_8mhz,0,1,clk_2mhz);

module CLK #(parameter N = 5000000)(
    input clk_Xhz,
    input rst,
    input enable,
    output reg Q
    );
    reg [29:0]cnt;
    wire [29:0]n;
    
    assign n = N >> 1;

    always @ (posedge clk_Xhz or posedge rst)
    begin
        if(rst)
        begin
            Q <= 0;
            cnt <= 30'b0;
        end
        else
        begin
            if(enable)
            begin
                if(cnt >= n)             
                begin                    
                    Q <= ~Q;             
                    cnt <= 30'b0;        
                end                      
                else cnt <= cnt + 30'b1; 
            end 
        end
    end
endmodule
