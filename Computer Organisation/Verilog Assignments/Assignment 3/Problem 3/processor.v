`timescale 1ns / 1ps
module processor(opcode, num1, num2, write_enable, FinalOutput, FlagCarry, FlagZero, FlagNegative, InvalidBit  );	

// Input-Output Declaration

input wire [2:0] opcode;
input wire [3:0] num1,num2;
input wire write_enable;

output wire [3:0] FinalOutput;
output wire FlagCarry, FlagZero, FlagNegative, InvalidBit;

// Intermediate Calculation Registers and Wires

reg Out,Carry_F, Zero_F, Negative_F, invalid_bit;
wire [3:0] temp1, temp2, out1;
wire carry_f, zero_f, negative_f;

// Core Function of Processor happening here

// temp1 and temp2 are the numbers stored in register-file at address num1 and num2  

regfile uut (.rr1(num1), .rr2(num2), .wr(num1), wdata(num2),	
	.wenable(write_enable), .w1(temp1), .w2(temp2) );

alu4 uut (.n1(temp1),.n2(temp2),.op(opcode[1:0]),.out(out1),
	.carryf(carry_f),.zerof(zero_f),.negativef(negative_f));

always @(*) begin

	if opcode[2] ==1 begin					// Register Case

		if opcode[1:0] == 2'b00 begin
			
			invalid_bit <= 0;
			Zero_F <= 0;
			Negative_F <=0;
			Carry_F <=0;
			Out <=4'b000;
		end	

		else begin				// Invalid Case for opcode other than 100 starting with 1
			
			invalid_bit <= 1;
			Zero_F <= 0;
			Negative_F <=0;
			Carry_F <=0;
			Out <=4'b000;
		end
	
	end

	else begin								// ALU Case

		invalid_bit <= 0;
		Zero_F <= zero_f;
		Negative_F <= negative_f;
		Carry_F <= carry_f;
		Out <= out1;
	end
	
end

assign FinalOutput= Out;
assign FlagCarry Carry_F;
assign FlagZero = Zero_F;
assign FlagNegative = Negative_F;
assign InvalidBit= invalid_bit;

endmodule
