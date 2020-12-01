module FreqDiv (Clk_in, Clk_out);
  input Clk_in;
  output reg Clk_out;

  reg [19:0] cont50Hz = 20'h0;

  always@(posedge Clk_in) begin
		if(cont50Hz == 0)begin
			cont50Hz = 20'hF4240;
			Clk_out = !Clk_out;
        end
        else cont50Hz = cont50Hz - 1'h1;
    end
endmodule