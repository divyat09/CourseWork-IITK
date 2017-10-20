`timescale 1ns / 1ps
module processor(clk, n,p,FlagCarry, FlagZero, FlagNegative, InvalidBit, sf_e, e, rs, rw, d, c, b, a  );	

// Input and Output Port Declaration

input wire clk; 
input wire [3:0] n,p;

output wire FlagCarry, FlagZero, FlagNegative, InvalidBit;

// Output Ports for LCD Display

output reg sf_e;     			// 1 LCD access (0 strataFlash access)
output reg e;        			// enable (1)
output reg rs;	  			// Register Select (1 data bits for R/W)
output reg rw;	  			// Read/Write 1/0

output reg d;	     			// 4th data bits (to form a nibble)
output reg c;	     			// 3rd data bits (to form a nibble)
output reg b;	    			// 2nd data bits (to form a nibble)
output reg a;	    			// 1st data bits (to form a nibble)


// Register Declaration for intermediate calclations

reg [3:0] num1, num2, temp1, temp2;
reg [2:0] opcode;
reg write_enable;

wire signed[3:0] T1, T2, out1;
wire carry_f, zero_f, negative_f;
reg Carry_F, Zero_F, Negative_F, invalid_bit;

// Regiser Declaration for intermediate calclations for LCD Display

reg [26:0] count = 0;	            			// 27-bit count, 0-(128M-1), over 2 secs
reg [5:0] code;	                     			// 6-bits different signals to give out
reg refresh;						 			// refresh LCD rate @ about 25Hz
reg [3:0] regfile [15:0];

// Assigning values to input registers from input Ports
initial begin
regfile[0]=0;
regfile[1]=0;
regfile[2]=0;
regfile[3]=0;
regfile[4]=0;
regfile[5]=0;
regfile[6]=0;
regfile[7]=0;
regfile[8]=0;
regfile[9]=0;
regfile[10]=0;
regfile[11]=0;
regfile[12]=0;
regfile[13]=0;
regfile[14]=0;
regfile[15]=0;
end
always @(posedge clk) begin

	if (p[0] ==1) begin				// Push Button North: Number 1 ( Write Register)
		num1[0] <= n[0];
		num1[1] <= n[1];
		num1[2] <= n[2];
		num1[3] <= n[3];
	end

	if (p[1] ==1) begin				// Push Button South: Number 2 (Write Data)
		num2[0] <= n[0];	
		num2[1] <= n[1];
		num2[2] <= n[2];
		num2[3] <= n[3];
	end

	if (p[2] ==1) begin				// Push Button West: OpCode
		opcode[0] <= n[0];
	    opcode[1] <= n[1];
		opcode[2] <= n[2];	
	end

	if (p[3] ==1) begin				// Push Button East: Write Enable
		write_enable <= n[0];
	end

end

// Processor core function implemented here
always @(*) begin
	if(write_enable) begin
		regfile[num1] <= num2;
	end
end

assign T1= regfile[num1];
assign T2= regfile[num2];

//regfile4x16 t1 (.rr1(num1), .rr2(num2), .wr(num1), .wdata(num2), .wenable(write_enable), .w1(T1), .w2(T2) );

alu4 t2 (.n1(T1),.n2(T2),.op(opcode[1:0]),.out(out1),.carryf(carry_f),.zerof(zero_f),.negativef(negative_f));

always @(opcode) begin				

	if (opcode[2] ==1) begin					// Register Case

		if (opcode[1:0] == 2'b00) begin

			invalid_bit <= 0;
			Zero_F <= 0;
			Negative_F <=0;
			Carry_F <=0;
		end	

		else begin			// Invalid Case for opcode other than 100 starting with 1
			invalid_bit <= 1;
			Zero_F <= 0;
			Negative_F <=0;
			Carry_F <=0;
		end
	
	end

	else begin								// ALU Case
		invalid_bit <= 0;
		Zero_F <= zero_f;
		Negative_F <= negative_f;
		Carry_F <= carry_f;
	end
	
end


// Assigning Ouput Flags the required values

assign FlagCarry= Carry_F;
assign FlagZero = Zero_F;
assign FlagNegative = Negative_F;
assign InvalidBit= invalid_bit;


// Converting ASCII to Hexadecimal for various cases

always @(out1) 						
if (out1 ==0 )begin	
	temp1 <= 6'h23;  
	temp2 <= 6'h20;
end

else if (out1 ==1 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h21;
end

else if (out1 ==2 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h22;
end

else if (out1 ==3 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h23;
end

else if (out1 ==4 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h24;
end

else if (out1 ==5 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h25;	
end

else if (out1 ==6 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h26;
end

else if (out1 ==7 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h27;
end

else if (out1 ==8 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h28;	
end

else if (out1 ==9 ) begin
	temp1 <= 6'h23;  
	temp2 <= 6'h29;	
end

else if (out1 ==10 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h21;	
end

else if (out1 ==11 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h22;	
end

else if (out1 ==12 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h23;	
end

else if (out1 ==13 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h24;	
end

else if (out1 ==14 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h25;	
end

else if (out1 ==15 ) begin
	temp1 <= 6'h24;  
	temp2 <= 6'h26;	
end


// Displaying the result on LCD screen

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