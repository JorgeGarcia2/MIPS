// Code your design here
module InstrDataMem(We, Clk, Addr, Wd, Rd);
  input We, Clk;
  input [31:0] Addr, Wd;
  output reg [31:0] Rd;
 
  reg [31:0] MEM[63:0];

  initial begin
    $readmemh("D:/Bibliotecas/Documents/Repositorios/Multicycle/Sources/instrData_data.hex", MEM); 
  end
  always @(posedge Clk) begin
    //$display("Addr %d MEM %d", Addr, MEM[Addr]);
	  if (We) begin // write enable
		  MEM[Addr] <= Wd;
	end
end
 
  assign Rd = MEM[Addr]; // word aligned
endmodule