`timescale 1 ns/10 ps

module counter(
	input wire set, reset,
	input wire[3:0] init,
	input wire clock,
	output wire[3:0] out
);

reg [3:0] count;					// count will store the current number to be displayed
reg [25:0] counter=50_000_000;	    // A counter to keep track of one second time

always @(posedge clock)

if (counter == 0) 
	begin
		counter <= 50_000_000;			

		if (reset) begin			// Reset starts counting from zero
			count <=4'b0;
		end 
		
		else if (set) begin			// Set begins counting from init
			count <= init;
		end 
		
		else begin
			count <= count+1;		
			if (count>4'b1111) begin
				count<=4'b0;
			end
		end
	end

else 
	begin
		counter <= counter - 1;	
	end	


assign out=count;					// Assigning the output

endmodule

