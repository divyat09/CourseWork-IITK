`timescale 1 ns/10 ps

module eq4(
	input wire clock,
	input wire [3:0] n0,	// Slider Input
	input wire p1, p2,		// Push Buttons
	output wire res2
);

reg [3:0] n1, n2;			// Two 4 bit numbers to be compared	
wire x1, x2;

always @(posedge clock)

if (p1==1) begin			// If push button North, Then input of slider to n1
	n1 <= n0;
end

if (p2==1) begin			// If push button South, Then input of slider to n2
	n2 <= n0;
end

eq2 Lower_Half (.a(n1[1:0]), .b(n2[1:0]), .res1(x1));
eq2 Upper_Half (.a(n1[3:2]), .b(n2[3:2]), .res1(x2));

assign res2= x1 & x2;

endmodule