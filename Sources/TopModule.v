`include "Alu.v"
`include "AluControl.v"
`include "Flopenr_2.v"
`include "Flopenr.v"
`include "InstrDataMem.v"
`include "MainControl.v"
`include "Mux2.v"
`include "Mux4.v"
`include "RegMem.v"
`include "SignExt.v"

module TopModule(Clk, Rst);
  input Clk, Rst;

  wire IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA, Branch, Zero, NEF;
  wire [31:0] PCp, Pc, ALUOut, Adr, A, B, RD, Instr, Data, WD3, RD1, RD2, SignImm, SrcA, SrcB, ALUResult;
  wire [4:0] A3;
  wire [1:0] ALUOp, PCSrc, ALUSrcB;
  wire [2:0] ALUControl;

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
  Mux4 MuxALUB(ALUSrcB, B, 1, SignImm, SignImm, SrcB);
  
  AluControl ALUC(Instr[5:0], ALUOp, ALUControl); //ALUOp
  Alu ALU(ALUControl, SrcA, SrcB, ALUResult, Zero); //ALUControl
  Flopenr #(32) FlopALU(Clk, 1'b0, 1'b1, ALUResult, ALUOut); //Ese 0 es el reset y el 1 es el enable

  Mux4 MuxPCsrc(PCSrc, ALUResult, ALUOut, {Pc[31:26],Instr[25:0]}, {Pc[31:26],Instr[25:0]}, PCp);
  MainControl Control(Clk,Rst,Instr[31:26],IorD,MemWrite,IRWrite,RegDst, MemtoReg,RegWrite,ALUSrcA,ALUSrcB,ALUOp,Branch,PCWrite,PCSrc,NEF);

endmodule