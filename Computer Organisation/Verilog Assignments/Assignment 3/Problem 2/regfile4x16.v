`timescale 1ns / 1ps
module regfile4x16(clk,b,p,r,w1,w2);	

input wire clk;
input wire [3:0] b,p; 
input wire r;
output wire [3:0] w1,w2;

reg [3:0] regfile [15:0];
reg [3:0] rr1, rr2, wr, wdata, t1, t2;
reg wenable;

always @(posedge clk) begin

	if (p[0]==1) begin
		rr1[0] <= b[0];
		rr1[1] <= b[1];
		rr1[2] <= b[2];
		rr1[3] <= b[3];
	end
	else if (p[1]==1) begin
		rr2[0] <= b[0];
		rr2[1] <= b[1];
		rr2[2] <= b[2];
		rr2[3] <= b[3];
	end
	else if (p[2]==1) begin
		wr[0] <= b[0];
		wr[1] <= b[1];
		wr[2] <= b[2];
		wr[3] <= b[3];
	end
	else if (p[3]==1) begin
		wdata[0] <= b[0];
		wdata[1] <= b[1];
		wdata[2] <= b[2];
		wdata[3] <= b[3];
	end

	if(r) begin
		wenable <= 1;
	end

end

always @(posedge clk) begin
	if(wenable) begin
		regfile[wr] <= wdata;
	end
end

assign w1= regfile[rr1];
assign w2= regfile[rr2];

endmodule	
