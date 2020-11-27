module flopenr_2 #(parameter WIDTH = 8)
  (input clk, reset,
   input en,
   input [WIDTH-1:0] d1, d2,
   output reg [WIDTH-1:0] q1, q2);

  always @(posedge clk, posedge reset)
    begin
      if (reset) begin q1 <= 0; q2 <= 0; end
      else if (en) begin q1 <= d1; q2 <= d2; end
    end

endmodule