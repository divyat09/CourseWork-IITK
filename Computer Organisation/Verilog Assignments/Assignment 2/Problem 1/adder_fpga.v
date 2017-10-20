`timescale 1ns / 1ps
module adder(clk, b0, b1, b2 ,b3 , p1, p2, cout, sf_e, e, rs, rw, d, c, b, a);

// Input- Ouput Port Declaration

input clk; 		
input wire b0;		// Slide Switch 0
input wire b1;		// Slide Switch 1
input wire b2;		// Slide Switch 2
input wire b3;		// Slide Switch 3
input wire p1;		// Push button North
input wire p2;		// Push Button South
output wire cout;		// LED for Carry Out

output reg sf_e;     // 1 LCD access (0 strataFlash access)
output reg e;        // enable (1)
output reg rs;	  // Register Select (1 data bits for R/W)
output reg rw;	  // Read/Write 1/0
output reg d;	     // 4th data bits (to form a nibble)
output reg c;	     // 3rd data bits (to form a nibble)
output reg b;	    // 2nd data bits (to form a nibble)
output reg a;	    // 1st data bits (to form a nibble)

// Temporary Registers Declaration

reg [26:0] count = 0;	             // 27-bit count, 0-(128M-1), over 2 secs
reg [5:0] code;	                     // 6-bits different signals to give out
reg refresh;						 // refresh LCD rate @ about 25Hz

wire [3:0] sum;						// To show the sum of 2 numbers 
reg [5:0] temp1;					
reg [5:0] temp2;
reg [3:0] n1, n2;

// Assigning data to input registers using input ports

always @(posedge clk)

if (p1==1) begin					// If push button north, then input to n1
	n1[0] <= b0;
	n1[1] <= b1;
	n1[2] <= b2;
	n1[3] <= b3;
end

else if (p2==1) begin				// If push button south, then input to n2
	n2[0] <= b0;
	n2[1] <= b1;
	n2[2] <= b2;
	n2[3] <= b3;
end


assign {cout, sum} = n1+n2;			// Performing the addition

// Converting ASCII to Hexadecimal for various cases

always @(sum) 						// Converting ASCII to Hexadecimal for various cases
if (sum ==0 )begin	
	temp1 <= 6'h23;  
	temp2 <= 6'h20;
end

else if (sum ==1 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h21;
end

else if (sum ==2 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h22;
end

else if (sum ==3 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h23;
end

else if (sum ==4 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h24;
end

else if (sum ==5 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h25;	
end

else if (sum ==6 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h26;
end

else if (sum ==7 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h27;
end

else if (sum ==8 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h28;	
end

else if (sum ==9 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h29;	
end

else if (sum ==10 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h21;	
end

else if (sum ==11 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h22;	
end

else if (sum ==12 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h23;	
end

else if (sum ==13 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h24;	
end

else if (sum ==14 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h25;	
end

else if (sum ==15 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h26;	
end


// Displaying the result on LCD Screen

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