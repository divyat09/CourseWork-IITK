module regfile4x16(
	input [3:0]rr1,		// Read register 1
	input [3:0]rr2,		// Read register 2
	input [3:0]wr,		// Write register
	input [3:0]wdata,	// Write data port
	input wenable,		// Write enable port
	output [3:0] w1,	// Output port		
	output [3:0] w2);	// Output port

reg [3:0] regfile [15:0];

always @(*) begin
	if(wenable) begin
		regfile[wr] <= wdata;
	end
end

assign w1= regfile[rr1];
assign w2= regfile[rr2];

endmodule	

