module DispSeg(digit, outDisp);
  input [3:0] digit;
  output reg [7:0] outDisp;

  always @*
    casez(digit) 
      4'd0: outDisp <= 8'b0000_0011; // Digit 0
      4'd1: outDisp <= 8'b1001_1111; // Digit 1
      4'd2: outDisp <= 8'b0010_0101; // Digit 2
      4'd3: outDisp <= 8'b0000_1101; // Digit 3
      4'd4: outDisp <= 8'b1001_1001; // Digit 4
      4'd5: outDisp <= 8'b0100_1001; // Digit 5
      4'd6: outDisp <= 8'b0100_0001; // Digit 6
      4'd7: outDisp <= 8'b0001_1101; // Digit 7
      4'd8: outDisp <= 8'b0000_0001; // Digit 8
      4'd9: outDisp <= 8'b0000_1001; // Digit 9
      4'd10: outDisp <= 8'b000_1_0001; // Digit A
      4'd11: outDisp <= 8'b1100_0011; // Digit B
      4'd12: outDisp <= 8'b0110_0011; // Digit C
      4'd13: outDisp <= 8'b1000_0101; // Digit D
      4'd14: outDisp <= 8'b0110_0001; // Digit E
      4'd15: outDisp <= 8'b0111_0001; // Digit F
	  default: outDisp <= 8'b1111_1111; // ???
    endcase
endmodule