//Code for the FlopENR

//flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc); --> to call this module
module flopenr #(parameter WIDTH = 8)
  (input clk, reset,
  input en,
  input [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
	if (reset) q <= 0;
	else if (en) q <= d;

endmodule