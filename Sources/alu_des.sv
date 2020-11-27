module  Alu(AluCtrl, A, B, AluOut, Zero);
  input [31:0] A, B;
  input [2:0] AluCtrl;    
  output reg [31:0] AluOut;
  output reg Zero;
  
  assign Zero =  (AluOut==0); //zero set if AluOut == 0
  
  always@(*)
    begin
   	  case ( AluCtrl )	 
      	3'b000 : AluOut = (A & B); // and AluCtrl 000   
      	3'b001 : AluOut = (A | B); // or AluCtrl 000   
      	3'b010 : AluOut = A + B;  // add AluCtrl 010
      	3'b110 : AluOut = A - B; // sub AluCtrl 110
      	3'b111 : AluOut = (A < B) ? 32'b1 : 32'b0; // SLT //$s < $t  
   	    default: AluOut = 32'b0;
   	  endcase
    end
endmodule
