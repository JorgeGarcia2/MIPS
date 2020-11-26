// Program counter module
module Pc(Clk, Rst, En, InPc, OutPc);
  input Clk, Rst, En;
  input [31:0] InPc;
  output reg [31:0] OutPc;

  always @(posedge Clk or posedge Rst)
    begin
      if(En) begin
        if (Rst)  
          OutPc <= 0;
        else
          OutPc <= InPc;
      end
      else 
        OutPc<=32'bx;
  end	 
endmodule