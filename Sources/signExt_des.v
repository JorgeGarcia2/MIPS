module SignExt (DataIn, DataExt);
  input  [15:0] DataIn;
  output reg [31:0] DataExt;

	assign DataExt = {{16{DataIn[15]}}, DataIn};

endmodule