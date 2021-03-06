`timescale 1ns/1 ps
/*
module Testbench;
reg in_Clk_TB,Rst_TB;
wire [6:0] Led;
wire Clk;
*/

module Testbench;
  reg Clk_TB, Rst_TB,selButton;
  wire [6:0] Led;
  wire Clk_ou;
  wire [7:0] disp7Seg;
  wire [3:0] selDisp;
  reg [3:0] selSignal;
  

  TopModule UU1(Clk_TB, Rst_TB, Led, 1'b1, Clk_ou, disp7Seg, selDisp, selSignal, selButton);

  //TopModule UU1(in_Clk_TB, Rst_TB, Led, 1'b1, Clk);
  initial
    begin
      $dumpfile("TopModule.vcd");
      $dumpvars(0,Testbench);
      
      Clk_TB = 0;
      Rst_TB = 0;
		selSignal = 0;
		selButton = 0;
      #1.5 Rst_TB = 1;
      #0.5 Rst_TB = 0;
      #700
      //#30
      $finish;
    end
  
  always
    begin
      #1
      Clk_TB = ~Clk_TB;
    end
  
endmodule

/*
20020005
2003000c
2067fff7
00e22025
00642824
00a42820
10a70001
14a70001
00000000
0064202a
14800001
10800001
20050000
00e2202a
00853820
00e23822
ac67001c
8c020028
08000016
20020003
00000000
00000000
ac02002c
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
FFFFFFFF
*/