module AluControl(Func, AluOp, AluCtrl);
  input [5:0] Func;
  input [1:0] AluOp;
  output reg [2:0] AluCtrl;

  always_comb
    casez({AluOp,Func}) 
      8'b00zzzzzz: AluCtrl <= 3'b010; // add (lw/sw/addi)
      8'b01zzzzzz: AluCtrl <= 3'b110; // sub (beq)
      8'b10100000: AluCtrl <= 3'b010; // add (R-type)
      8'b10100010: AluCtrl <= 3'b110; // sub (R-type)
      8'b10100100: AluCtrl <= 3'b000; // and (R-type)
      8'b10100101: AluCtrl <= 3'b001; // or  (R-type)
      8'b10101010: AluCtrl <= 3'b111; // slt (R-type)
	  default: AluCtrl <= 3'bxxx; // ???
    endcase
endmodule