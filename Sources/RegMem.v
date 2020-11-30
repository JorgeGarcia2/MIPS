module RegMem (Clk, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);
  input Clk, RegWrite; 			
  input [4:0] ReadReg1, ReadReg2, WriteReg; 
  input [31:0] WriteData; 	
  output [31:0] ReadData1, ReadData2; 
  
  reg [31:0] RAM [31:0];
  
  initial
	  //$readmemh("../Sources/regMem_data.data", RAM, 0, 31); 
    //begin
      //$readmemh("../Sources/regMem_data.hex", RAM); 
	  $readmemh("../Sources/regMem_data.data", RAM, 0, 31); 
    //end
	
	always @(posedge Clk)
	begin
		if (RegWrite) 
		begin // write enable
			RAM[WriteReg] <= WriteData;
		end
	end
	
  assign ReadData1 = RAM[ReadReg1];
  assign ReadData2 = RAM[ReadReg2];
  
endmodule