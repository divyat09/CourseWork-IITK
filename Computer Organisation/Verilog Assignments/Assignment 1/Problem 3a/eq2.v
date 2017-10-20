`timescale 1 ns/10 ps

module eq2(
	input wire[1:0] a,b,
	output wire res1
);

wire r1, r2;

// Call to module eq1 which is 1 bit comparator
eq1 Bit0 (.i0(a[0]), .i1(b[0]), .eq(r1));			
eq1 Bit1 (.i0(a[1]), .i1(b[1]), .eq(r2));

assign res1= r1 & r2;					

endmodule