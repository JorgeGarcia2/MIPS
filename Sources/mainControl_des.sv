module MainControl(clk,reset,Op,IorD,MemWrite,IRWrite,RegDst, MemtoReg,RegWrite,ALUSrcA,ALUSrcB,ALUOp,Branch,PCWrite,PCSrc,NEF);
  input clk,reset;
  input [5:0] Op;
  output IorD,MemWrite, IRWrite,RegDst,MemtoReg,RegWrite,ALUSrcA,Branch,PCWrite,NEF;
  
  output [1:0] ALUSrcB,PCSrc,ALUOp;
  
  
  reg [15:0]Out_R;
  
  
  reg [3:0] state;
  reg [3:0] next_state;
  
  parameter s0=4'h0;
  parameter s1=4'h1;
  parameter s2=4'h2;
  parameter s3=4'h3;
  parameter s4=4'h4;
  parameter s5=4'h5;
  parameter s6=4'h6;
  parameter s7=4'h7;
  parameter s8=4'h8;
  parameter s9=4'h9;
  parameter s10=4'hA;
  parameter s11=4'hB;
  parameter s12=4'hC;

  initial begin
    //state=4'b00;
    state=s0;
  end
  
  assign {PCWrite,MemWrite,IRWrite,RegWrite,ALUSrcA,Branch,IorD,MemtoReg,RegDst,ALUSrcB,PCSrc,ALUOp,NEF} = Out_R ;
  
  //State Register
  always@(posedge clk or posedge reset)
    begin
      if(reset) state<=s0;
   	  else state<=next_state;
    end
  
  //Next state function
  always@(state or Op)
    begin
      case(state)
        s0: next_state=s1;
        s1:
        case(Op)
          6'h0: next_state=s6;
          6'h4: next_state=s8;
          6'h5: next_state=s12;
          6'h8: next_state=s9;
          6'h23: next_state=s2;
          6'h2b: next_state=s2;
          6'h02: next_state=s11;
          default: next_state=s0;
        endcase
        s2: next_state=(Op==6'h23)?s3:s5;
        s3: next_state=s4;
        s4: next_state=s0;
        s5: next_state=s0;
        s6: next_state=s7;
        s7: next_state=s0;
        s8: next_state=s0;
        s9: next_state=s10;
        s10: next_state=s0;
        s11: next_state=s0;
        s12: next_state=s0;
        default: next_state=s0;
      endcase
    end
 
  //output logic
  always@(state)
    begin
      case(state)
        s0: Out_R <= 16'b1010_0000_0010_0000;//A020
        s1: Out_R <= 16'b0000_0000_0110_0000;//0060
        s2: Out_R <= 16'b0000_1000_0100_0000;//0840
        s3: Out_R <= 16'b0000_0010_0000_0000;//0200
        s4: Out_R <= 16'b0001_0001_0000_0000;//1100
        s5: Out_R <= 16'b0100_0010_0000_0000;//4200
        s6: Out_R <= 16'b0000_1000_0000_0100;//0804
        s7: Out_R <= 16'b0001_0000_1000_0000;//1080
        s8: Out_R <= 16'b0000_1100_0000_1010;//0C0A
        s9: Out_R <= 16'b0000_1000_0100_0000;//0840
        s10: Out_R <= 16'b0001_0000_0000_0000;//1000
        s11: Out_R <= 16'b1000_0000_0001_0000;//8010
        s12: Out_R <= 16'b0000_1100_0000_1011;//0C0B
    	default: Out_R <= 16'b0000_xxxxx_xxxx_xx_x;
      endcase
    end
  
  
endmodule