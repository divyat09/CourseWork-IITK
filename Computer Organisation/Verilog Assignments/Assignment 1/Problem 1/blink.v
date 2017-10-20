`timescale 1ns / 1ps

module blink(
	clk,	// clock signal
	ledpin	// LED pin
    );

	// inputs and outputs
	input clk;

	output ledpin;
	reg ledpin = 0;	

	// internal variable
	reg [25:0] counter = 50_000_000;	// 26 bit variable

	always @(posedge clk)
	if (counter == 0) begin			// at 1 second
		counter <= 50_000_000;		// reset counter
		ledpin <= !ledpin;		// invert ledpin
	end else begin
		counter <= counter - 1;		// decrease
	end

endmodule