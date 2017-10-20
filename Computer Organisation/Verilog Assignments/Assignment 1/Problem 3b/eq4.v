`timescale 1 ns/10 ps

module eq4(
	input wire [3:0] n1, n2,
	output wire res2
);

wire x1, x2;

// Call to module eq2 which is 2 bit comparator
eq2 Lower_Half (.a(n1[1:0]), .b(n2[1:0]), .res1(x1));
eq2 Upper_Half (.a(n1[3:2]), .b(n2[3:2]), .res1(x2));

assign res2= x1 & x2;

endmodule