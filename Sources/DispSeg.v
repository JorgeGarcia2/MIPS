//`include "DivFreq.sv"
module DispSeg(clk, d1, d2, d3, d4, outDisp, selDisp);
  input clk;
  input [3:0] d1, d2, d3, d4;
  output reg [7:0] outDisp;
  output reg [3:0] selDisp;
  
  //reg clk_1k;
  reg [3:0] digit=0;
  reg [1:0] cont=0;
	
  //FreqDiv  #(2) FD_1KHz (clk, clk_1k);
  /*
  //cont inicia en 0
  initial begin
    cont = 0;
  end
  */
  always@(posedge clk) begin
	if(cont==3) cont=0;
	else cont = cont + 1;
  end
  //assign selDisp = ~( 1 << cont );
  //Bloque para asignar los digitos a digit
  always @*
    case(cont) 
      0: begin digit <= d1;
      	 selDisp <= 4'b1110; // Digit 0
		 end
      1: begin digit <= d2;
      	 selDisp <= 4'b1101; // Digit 1
		 end
      2: begin digit <= d3; 
      	 selDisp <= 4'b1011; // Digit 2
		 end
      3: begin digit <= d4; 
      	 selDisp <= 4'b0111; // Digit 3
		 end
	  default: begin digit <= 4'b0; 
      		   selDisp <= 4'b0000; // ???
			   end
    endcase
  

  always @*
    case(digit) 
      4'd0: outDisp <= 8'b0000_0011; // Digit 0
      4'd1: outDisp <= 8'b1001_1111; // Digit 1
      4'd2: outDisp <= 8'b0010_0101; // Digit 2
      4'd3: outDisp <= 8'b0000_1101; // Digit 3
      4'd4: outDisp <= 8'b1001_1001; // Digit 4
      4'd5: outDisp <= 8'b0100_1001; // Digit 5
      4'd6: outDisp <= 8'b0100_0001; // Digit 6
      4'd7: outDisp <= 8'b0001_1111; // Digit 7
      4'd8: outDisp <= 8'b0000_0001; // Digit 8
      4'd9: outDisp <= 8'b0000_1001; // Digit 9
      4'd10: outDisp <= 8'b0001_0001; // Digit A
      4'd11: outDisp <= 8'b1100_0001; // Digit B
      4'd12: outDisp <= 8'b0110_0011; // Digit C
      4'd13: outDisp <= 8'b1000_0101; // Digit D
      4'd14: outDisp <= 8'b0110_0001; // Digit E
      4'd15: outDisp <= 8'b0111_0001; // Digit F
	  default: outDisp <= 8'b1111_1111; // ???
    endcase
endmodule