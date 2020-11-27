module DispSeg(digit, outDisp);
  input [3:0] digit;
  output reg [6:0] outDisp;

  always @*
    casez(digit) 
      4'd0: outDisp <= 7'b000_0001; // Digit 0
      4'd1: outDisp <= 7'b100_1111; // Digit 1
      4'd2: outDisp <= 7'b001_0010; // Digit 2
      4'd3: outDisp <= 7'b000_0110; // Digit 3
      4'd4: outDisp <= 7'b100_1100; // Digit 4
      4'd5: outDisp <= 7'b010_0100; // Digit 5
      4'd6: outDisp <= 7'b010_0000; // Digit 6
      4'd7: outDisp <= 7'b000_1110; // Digit 7
      4'd8: outDisp <= 7'b000_0000; // Digit 8
      4'd9: outDisp <= 7'b000_0100; // Digit 9
      4'd10: outDisp <= 7'b000_1000; // Digit A
      4'd11: outDisp <= 7'b110_0001; // Digit B
      4'd12: outDisp <= 7'b011_0001; // Digit C
      4'd13: outDisp <= 7'b100_0010; // Digit D
      4'd14: outDisp <= 7'b011_0000; // Digit E
      4'd15: outDisp <= 7'b011_1000; // Digit F
	  default: outDisp <= 7'b111_1111; // ???
    endcase
endmodule