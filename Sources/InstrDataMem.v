module InstrDataMem(We, Clk, Addr, Wd, Rd);
  input We, Clk;
  input [31:0] Addr, Wd;
  output wire [31:0] Rd;
 
  reg [31:0] MEM[95:0];

  initial 
    //$readmemh("../Sources/instrData_data.data", MEM, 0, 63); 
  begin
    //$readmemh("../Sources/instrData_data.hex", MEM); 
      $readmemh("../Sources/instrData_data.data", MEM, 0, 95); 
    //$readmemh("../Sources/instrData_data.coe", MEM); 
    //$readmemh("InstrMem.mem", MEM); 
  end
  
	always @(posedge Clk) 
	begin
    //$display("Addr %d MEM %d", Addr, MEM[Addr]);
	  if (We) 
		begin // write enable
		  MEM[Addr] <= Wd;
		end
	end
 
  assign Rd = MEM[Addr]; // word aligned
endmodule