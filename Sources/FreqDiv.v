module FreqDiv #(parameter FREQ = 4)(En, Clk_in, Clk_out);
  input Clk_in,En;
  output reg Clk_out;

  reg [23:0] contHz = 0;
  initial begin
    Clk_out = 0;
  end

  always@(posedge Clk_in) begin
		if(En)
		begin
			if(contHz == 0)begin
				contHz = FREQ-1;
				Clk_out = !Clk_out;
			end
			else contHz = contHz - 1'h1;
		end
    end
endmodule