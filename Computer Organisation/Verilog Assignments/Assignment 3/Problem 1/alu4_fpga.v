`timescale 1ns / 1ps
module alu4(clk, b0, b1, b2 ,b3 , p1, p2,p3, carryf, zerof, negativef, sf_e, e, rs, rw, d, c, b, a);

input wire clk; 		
input wire b0;				// Slide Switch 0
input wire b1;				// Slide Switch 1
input wire b2;				// Slide Switch 2
input wire b3;				// Slide Switch 3
input wire p1;				// Push button North
input wire p2;				// Push Button South
input wire p3;				// Push Button West 

output wire carryf;			// LED for Carry flag
output wire zerof;			// LED for Zero flag
output wire negativef;		// LED for Negative flag

output reg sf_e;     			// 1 LCD access (0 strataFlash access)
output reg e;        			// enable (1)
output reg rs;	  			// Register Select (1 data bits for R/W)
output reg rw;	  			// Read/Write 1/0

output reg d;	     			// 4th data bits (to form a nibble)
output reg c;	     			// 3rd data bits (to form a nibble)
output reg b;	    			// 2nd data bits (to form a nibble)
output reg a;	    			// 1st data bits (to form a nibble)


reg signed [3:0] n1, n2;
reg [1:0] op;
reg signed[3:0] out, out_main, out_main2;
reg Zero_Flag, Negative_Flag, Carry_Flag;

reg [5:0] temp1,temp2; 
reg [26:0] count = 0;	            			// 27-bit count, 0-(128M-1), over 2 secs
reg [5:0] code;	                     			// 6-bits different signals to give out
reg refresh;						 			// refresh LCD rate @ about 25Hz


always @( posedge clk)

	if (p1==1) begin					// If push button north, then input to p1
		n1[0] <= b0;
		n1[1] <= b1;
		n1[2] <= b2;
		n1[3] <= b3;
	end

	else if (p2==1) begin				// If push button south, then input to p2
		n2[0] <= b0;
		n2[1] <= b1;
		n2[2] <= b2;
		n2[3] <= b3;
	end

	else if (p3==1) begin				// If push button is west, then input to op1
		op[0] <= b0;
		op[1] <= b1;
	end

always @(op) begin

	case(op)

		2'b00: 
		begin
			out_main <= n1 & n2;		// And of 2 input numbers
			
			Carry_Flag <= 0;
			
			// Setting Negative_Flag
			if (out_main[3]==1)	begin
				Negative_Flag <=1;
			end
			else begin
				Negative_Flag <=0;
			end		

		end
		 
		2'b01: 
		begin
			out_main <= n1 | n2;

			Carry_Flag<=0;

			// Setting Negative_Flag
			if (out_main[3]==1)	begin
				Negative_Flag <=1;
			end
			else begin
				Negative_Flag <=0;
			end

		end

		2'b10: 
		begin

			out_main <= n1 + n2;

			// Calcuating Carry Flag 
			if ( out_main[3]!=n1[3] && out_main[3]!=n2[3] ) begin
				Carry_Flag <=1;
			end
			else begin
				Carry_Flag <=0;
			end
			
			// Calculating  Negative Flag
			if ( n1[3]==n2[3]) begin				// Both +ve or both -ve
				Negative_Flag <= n1[3];	  // Adding 2 +ve always gives +ve and adding 2-ve always gives -ve		
			end			
			else begin
				Negative_Flag <= out_main[3];  // Because No Overflow can happen here. 								  // So,sign determined by MSB of result	
			end

		end

		2'b11: 
		begin
		
			out_main <= n1 - n2;

			// Calcuating Carry Flag 
			if ( n2[3]!=n1[3] && out_main[3]!=n1[3]  ) begin
				Carry_Flag<=1;
			end
			else begin
				Carry_Flag<=0;
			end

			// Calculating  Negative Flag
			if ( n1[3]!=n2[3]) begin				// One nuber is +ve and otheris -ve
				Negative_Flag <= n1[3];				// +ve - -ve = +ve and -ve - +ve = -ve
			end			
			else begin
				Negative_Flag <= out_main[3];	// Because No Overflow can happen here. 
											// So, sign determined by MSB of result
			end

		end
		default: out_main <= 0;

	endcase

end

always @(*) begin
	if (Negative_Flag==1) begin				// 2's complement for Negative Case
		out_main2[3] <= ~Negative_Flag;
		out_main2[0] <= ~out_main[0];
		out_main2[1] <= ~out_main[1];
		out_main2[2] <= ~out_main[2];

		out <= out_main2 + 4'b0001;
	end
	else begin							// MSB =0 for Positive Case
		out[3] <= Negative_Flag;
	end

	// Set Zero Flag
	if (out == 4'b0000) begin
		Zero_Flag <= 1;
	end
	else begin
		Zero_Flag <=0;
	end
end

assign zerof= Zero_Flag;
assign negativef= Negative_Flag;
assign carryf= Carry_Flag;

always @(out) 						// Converting ASCII to Hexadecimal for various cases

if (out ==0 )begin	
	temp1 <= 6'h23;  
	temp2 <= 6'h20;
end

else if (out ==1 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h21;
end

else if (out ==2 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h22;
end

else if (out ==3 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h23;
end

else if (out ==4 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h24;
end

else if (out ==5 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h25;	
end

else if (out ==6 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h26;
end

else if (out ==7 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h27;
end

else if (out ==8 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h28;	
end

else if (out ==9 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h27;	
end

else if (out ==10 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h26;	
end

else if (out ==11 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h25;	
end

else if (out ==12 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h24;	
end

else if (out ==13 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h23;	
end

else if (out ==14 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h22;	
end

else if (out ==15 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h21;	
end


always @ (posedge clk) begin					// Displaying it on the screen
count <= count + 1; 

case (count[26:21])	// as top 6 bits change
// power-on init can be carried out befor this loop to avoid the flickers
0: code <= 6'h03;	// power-on init sequence
1: code <= 6'h03;	// this is needed at least once
2: code <= 6'h03;	// when LCD's powered on
3: code <= 6'h02;	// it flickers existing char dislay
// Table 5-3, Function Set 
// Send 00 and upper nibble 0010, then 00 and lower nibble 10xx
4: code <= 6'h02; // Function Set, upper nibble 0010 
5: code <= 6'h08; // lower nibble 1000 (10xx)
// Table 5-3, Entry Mode 
// send 00 and upper nibble: I/D bit (Incr 1, Decr 0), S bit (Shift 1, 0 no) 
6: code <= 6'h00; // see table, upper nibble 0000, then lower nibble: 
7: code <= 6'h06; // 0110: Incr, Shift disabled
// Table 5-3, Display On/Off 
// send 00 and upper nibble 0000, then 00 and lower nibble 1 DCB 
// D: 1, show char represented by code in DDR, 0 don't, but code remains 
// C: 1, show cursor, 0 don't 
// B: 1, cursor blinks (if shown), 0 don't blink (if shown) 
8: code <= 6'h00; // Display On/Off, upper nibble 0000 
9: code <= 6'h0C; // lower nibble 1100 (1 D C B)
10: code <= 6'h00; // Clear Display, 00 and upper nibble 0000 
11: code <= 6'h01; // then 00 and lower nibble 0001 
12: code <= temp1;
13: code <= temp2;
 
default: code <= 6'h10; // the restun-used time 
endcase 
// refresh (enable) the LCD when bit 20 of the count is 1 
// (it flips when counted upto 2M, and flips again after another 2M) 
refresh <= count[ 20 ]; // flip rate about 25 (50MHz/2*21=2M) 
sf_e <= 1; e <= refresh; 
rs <= code[5]; rw <= code[4]; 
d <= code[3]; c <= code[2]; 
b <= code[1]; a <= code[0]; 
end // always

endmodule
