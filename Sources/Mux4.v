module Mux4 #(parameter WIDTH = 32) (Sel, In0, In1, In2, In3, Out);
  input [1:0] Sel;
  input [WIDTH-1:0] In0,In1,In2,In3;
  output reg [WIDTH-1:0] Out;

  always @(*)
    case(Sel)
      2'b00 : Out = In0;
      2'b01 : Out = In1;
      2'b10 : Out = In2;
      2'b11 : Out = In3;
      default: Out = 0;
    endcase
endmodule