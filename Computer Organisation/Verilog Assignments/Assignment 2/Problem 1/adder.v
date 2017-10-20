module adder(
  input wire [3:0] n1, n2,			// Two input binary numbers	
  output wire [3:0] sum,
  output wire cout					// Carrry out
);

assign {cout, sum} = n1+n2; 		// Performing the sum of 2 input numbers
endmodule

