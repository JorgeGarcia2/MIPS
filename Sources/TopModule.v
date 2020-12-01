`timescale 1ns/1ps

`include "ALU.v"
`include "ALUControl.v"
`include "Flopenr.v"
`include "InstrDataMem.v"
`include "MainControl.v"
`include "Mux2.v"
`include "Mux4.v"
`include "RegMem.v"
`include "SignExt.v"
`include "DispSeg.v"


//module TopModule(in_Clk, Rst, Led,EnClk,Clk, disp7Seg,selDisp, selSignal,selButton);
module TopModule(in_Clk, Rst, Led,EnClk,Clk, disp7Seg,selDisp, in_Data,SW_En_Data,selButton,Data_Mux);
  input in_Clk, Rst, EnClk, selButton,SW_En_Data,Data_Mux;
  input [2:0] in_Data;
  output wire [6:0] Led;
  output wire Clk;
  output wire [7:0] disp7Seg;
  output wire [3:0] selDisp;

  wire IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, Zero, NEF;
  wire [31:0] PCp, Pc, ALUOut, Adr, A, B, RD, Instr, Data, WD3, RD1, RD2, SignImm, SrcA, SrcB, ALUResult;
  wire [4:0] A3;
  wire [1:0] ALUOp, PCSrc, ALUSrcB;
  wire [2:0] ALUControl;
  
  
  ////////////////////////////////////////////////////////////////////////////////////////Shield
  //frequency divider //50MHZ -> 50HZ
	reg Hz50CLK = 1'h0;
	reg [19:0] cont50Hz = 20'h0;
	always@(posedge in_Clk)
	begin
		if(cont50Hz==0)begin
			cont50Hz = 20'hF4240;
			//cont50Hz = 20'h1;
			Hz50CLK=!Hz50CLK;end
		else begin cont50Hz=cont50Hz-1'h1; end
	end
	//Bounce filter register
	reg [3:0] bReg=4'h0;
	reg [3:0] tmpReg=4'h0;
	wire clkEN;
	always@(posedge Hz50CLK)
	begin
	/////////////////antirrebotes
		bReg[3]=bReg[2];
		bReg[2]=bReg[1];
		bReg[1]=bReg[0];
		bReg[0]=EnClk;
	end
	
	assign clkEN=&bReg;
	
	reg [15:0] cont1kHz;
	reg CLKD2x;//1KHZ CLK DISPLAY
	always@(posedge in_Clk)
	begin	
		if(cont1kHz==0) 
			begin cont1kHz=16'hC350;  CLKD2x=!CLKD2x;end
		else begin cont1kHz=cont1kHz-1'h1; end
	end

	//DISPLAY MULTIPLEXER COUNTER
	reg [1:0] contDisplay = 2'h3;
	always@(posedge CLKD2x)
	begin
		if(contDisplay==0) 
			begin contDisplay=2'h3; end
		else begin contDisplay=contDisplay-1'h1; end
	end

	//DISPLAY SELECTOR
	assign selDisp=(contDisplay==2'h3)? 4'b0111:
						(contDisplay==2'h2)? 4'b1011:
						(contDisplay==2'h1)? 4'b1101:
						4'b1110;
	
	//SHOW EACH DISPLAY
	
	reg Finish_F;
	wire [3:0] Ctrl_State;
  
	wire [15:0] valShow;
	reg [15:0] Pc_state;
	reg [15:0] MemData_RegData;
	
   Mux2 #(16) MuxDisplay(Data_Mux, Pc_state, MemData_RegData, valShow);
	
	always@(negedge Clk)
	begin
		if(!Finish_F) begin
			if(RegWrite) begin
				MemData_RegData[15:8]=WD3[7:0];
			end
			if(MemWrite) begin
				MemData_RegData[7:0]=B[7:0];
			end
			Pc_state={Pc[7:0],4'h0,Ctrl_State};
		end
	end
	
	//SHOW SYMBOLS IN DISPLAY (DECODER)
	wire [3:0] s;

	assign s=(contDisplay==2'h3)? valShow[15:12]: //DISPLAY 1 "S"
				(contDisplay==2'h2)? valShow[11:8] : //DISPLAY 2 "_"
				(contDisplay==2'h1)? valShow[7:4]  : //DISPLAY 3 "0"
				(contDisplay==2'h0)? valShow[3:0]  : //DISPLAY 4  "DATO"
				4'b1111; //EXTRA
	
	DispSeg DS(s,disp7seg);
  
  reg Hz1CLK = 1'h0;
  assign Clk=(clkEN==1'h1)? Hz1CLK:1'h0;  //en lugar de 0 va la entrada del bus
  
  assign Led[2:0] = in_Data[2:0]; //concatenar los bits de CONTROL
  assign Led[5:3] = 3'h0; //concatenar los bits de CONTROL 
  assign Led[6] = Finish_F; //concatenar los bits de CONTROL
  
  reg [31:0] contHz=32'h0;
  
	always@(posedge in_Clk)
	begin
		
		if(Rst==1)
		begin
			Finish_F=0;
		end
		else begin
		Finish_F=(Instr==32'hFFFFFFFF)? 1 : 0;
		end
			if(Finish_F==0)
			begin
				if(contHz==0)
					begin
					//contHz=32'h1;
					contHz=32'h00FAF080; //32'h01FAF080
					Hz1CLK=!Hz1CLK;
					end
				else
					begin
						contHz=contHz-1'h1;
					end
			end
	end
  //END SHIELD


  Flopenr #(32) FlopPc(Clk, Rst, (PCWrite|(Branch&(Zero^NEF))), PCp, Pc); //PC flip-flop
  Mux2 #(32) mux_PC(IorD, Pc, ALUOut, Adr); //IorD
  InstrDataMem IDmem(MemWrite, Clk, Adr, B, RD); //MemWrite
  Flopenr #(32) Flop0(Clk, 1'b0, IRWrite, RD, Instr); //Instruction
  Flopenr #(32) Flop1(Clk, 1'b0, 1'b1, RD, Data); //Data
  Mux2 #(5) MuxRF1(RegDst, Instr[20:16], Instr[15:11], A3);
  Mux2 #(32) MuxRF2(MemtoReg, ALUOut, Data, WD3);
  RegMem RegFile(Clk, RegWrite, Instr[25:21], Instr[20:16], A3, WD3, RD1, RD2);
  SignExt SExtend(Instr[15:0], SignImm);
  
  Flopenr #(32) FlopRF1(Clk, 1'b0, 1'b1, RD1, A); //FF1-Register file
  Flopenr #(32) FlopRF2(Clk, 1'b0, 1'b1, RD2, B); //FF2-Register file

  Mux2 #(32) MuxALUA(ALUSrcA, Pc, A, SrcA);
  //Mux4 MuxALUB(ALUSrcB, B, 1, SignImm, SignImm, SrcB);
  Mux4 MuxALUB((ALUSrcB[1])?{1'h1,SW_En_Data}:ALUSrcB, B, 32'h1, SignImm, {29'h0,in_Data}, SrcB);
  
  ALUControl ALUC(Instr[5:0], ALUOp, ALUControl); //ALUOp
  ALU ALU(ALUControl, SrcA, SrcB, ALUResult, Zero); //ALUControl
  Flopenr #(32) FlopALU(Clk, 1'b0, 1'b1, ALUResult, ALUOut); //Ese 0 es el reset y el 1 es el enable

  Mux4 MuxPCsrc(PCSrc, ALUResult, ALUOut, {Pc[31:26],Instr[25:0]}, {Pc[31:26],Instr[25:0]}, PCp);
  MainControl Control(Clk,Rst,Instr[31:26],IorD,MemWrite,IRWrite,RegDst, MemtoReg,RegWrite,ALUSrcA,ALUSrcB,ALUOp,Branch,PCWrite,PCSrc,NEF,Ctrl_State);

endmodule