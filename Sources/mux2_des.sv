module Mux2 #(parameter WIDTH = 32) (Sel, A, B, Out);
  input Sel;
  input [WIDTH-1:0] A,B;
  output reg [WIDTH-1:0] Out;

  always @(*)
    case(Sel)
      1'b0 : Out = A;
      1'b1 : Out = B; 
    endcase
endmodule