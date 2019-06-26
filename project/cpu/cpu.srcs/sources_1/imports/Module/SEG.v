module SEG(
    input clk_4khz,
    input [7:0] en, //pos
    input [7:0] dp_x, //pos
    input [3:0] x0,x1,x2,x3,x4,x5,x6,x7,
    output [7:0]AN,
    output DP,
    output reg [6:0]seg 
    );

    
    reg [2:0] state,next_state;
    reg [7:0] an;
    reg dp;
    wire [6:0]seg0,seg1,seg2,seg3,seg4,seg5,seg6,seg7;
    
    bcd_to_seg b0(x0,seg0);
    bcd_to_seg b1(x1,seg1);
    bcd_to_seg b2(x2,seg2);
    bcd_to_seg b3(x3,seg3);      
    bcd_to_seg b4(x4,seg4); 
    bcd_to_seg b5(x5,seg5);
    bcd_to_seg b6(x6,seg6);      
    bcd_to_seg b7(x7,seg7);

    assign AN = an | ~en;
    assign DP = ~dp;
    
    always @ (posedge clk_4khz)
        begin
            state <= next_state;
        end

    always @(state)
    begin
        case(state)
            3'b000: next_state = 3'b001;
            3'b001: next_state = 3'b010;
            3'b010: next_state = 3'b011;
            3'b011: next_state = 3'b100;
            3'b100: next_state = 3'b101;
            3'b101: next_state = 3'b110;
            3'b110: next_state = 3'b111;
            3'b111: next_state = 3'b000;
            default: next_state = 3'b000;
        endcase
    end


    always @ (posedge clk_4khz)
        begin
            case(state)
                3'b000:
                begin
                an = 8'b11111110;
                dp = dp_x[0];
                seg = seg0;
                end
                3'b001:
                begin
                an = 8'b11111101;
                dp = dp_x[1];
                seg = seg1;
                end
                3'b010:
                begin
                an = 8'b11111011;
                dp = dp_x[2];
                seg = seg2;
                end
                3'b011:
                begin
                an = 8'b11110111;
                dp = dp_x[3];
                seg = seg3;
                end
                3'b100:
                begin
                an = 8'b11101111;
                dp = dp_x[4];
                seg = seg4;
                end
                3'b101:
                begin
                an = 8'b11011111;
                dp = dp_x[5];
                seg = seg5;
                end
                3'b110:
                begin
                an = 8'b10111111;
                dp = dp_x[6];
                seg = seg6;
                end
                3'b111:
                begin
                an = 8'b01111111;
                dp = dp_x[7];
                seg = seg7;
                end
                default:
                begin
                an = 8'b11111110;
                seg = seg0;
                dp = dp_x[0];
                end
            endcase
        end
endmodule

module bcd_to_seg(
    input [3:0] x,
    output reg [6:0]seg);
    always @ (x)
        begin
            case(x)
                4'b0000:seg = 7'b1000000;
                4'b0001:seg = 7'b1111001;
                4'b0010:seg = 7'b0100100;
                4'b0011:seg = 7'b0110000;
                4'b0100:seg = 7'b0011001;
                4'b0101:seg = 7'b0010010;
                4'b0110:seg = 7'b0000010;
                4'b0111:seg = 7'b1111000;
                4'b1000:seg = 7'b0000000;
                4'b1001:seg = 7'b0010000;
                4'b1010:seg = 7'b0001000;
                4'b1011:seg = 7'b0000011;
                4'b1100:seg = 7'b0100111;
                4'b1101:seg = 7'b0100001;
                4'b1110:seg = 7'b0000110;
                4'b1111:seg = 7'b0001110;
                default:seg = 7'b1000000;
            endcase
        end
endmodule

