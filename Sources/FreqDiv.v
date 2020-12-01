module FreqDiv #(parameter FREQ = 4)(Clk_in, Clk_out);
  input Clk_in;
  output reg Clk_out;

  reg [19:0] contHz = 0;
  initial begin
    Clk_out = 0;
  end

  always@(posedge Clk_in) begin
		if(contHz == 0)begin
			contHz = FREQ;
			Clk_out = !Clk_out;
        end
        else contHz = contHz - 1'h1;
    end
endmodule