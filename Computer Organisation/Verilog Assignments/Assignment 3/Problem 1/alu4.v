module alu4(
  input wire signed [3:0] n1, n2,			// Two input binary numbers	
  input wire [1:0] op,				// Operation to be performed
  output wire signed	[3:0] out,			//Output of the operation
  output wire carryf,				// Flag for carry
  output wire zerof,				// Flag for zero
  output wire negativef				// Flag for negative
);

reg signed[3:0] out_main, out_main2, out_main3;
reg Zero_Flag, Negative_Flag, Carry_Flag;

always @(*) begin

	case(op)

		2'b00: 							// Case of AND
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
		 
		2'b01: 							// Case of OR
		begin
			out_main <= n1 | n2;

			Carry_Flag <=0;

			// Setting Negative_Flag
			if (out_main[3]==1)	begin
				Negative_Flag <=1;
			end
			else  begin
				Negative_Flag <=0;
			end

		end

		2'b10: 									     // Case of Add
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
				Negative_Flag <= n1[3];		// Adding 2 +ve always gives +ve and 									// adding 2-ve always gives -ve
			end			
			else begin
				Negative_Flag <= out_main[3];		// Because No Overflow can happen here.									// So, sign determined by MSB of result
			end

		end

		2'b11:										// Case of Subtract 
		begin
		
			out_main <= n1 - n2;

			// Calcuating Carry Flag 
			if ( n2[3]!=n1[3] && out_main[3]!=n1[3] ) begin
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
				Negative_Flag <= out_main[3];	// Because No Overflow can happen here. 								// So, sign determined by MSB of result
			end

		end
		default: out_main <= 0;
	endcase

end

always @(*) begin

	if (Negative_Flag==1) begin					
		out_main2[3] <= ~Negative_Flag;		// Taking 2's Complement for Negative Case
		out_main2[0] <= ~out_main[0];
		out_main2[1] <= ~out_main[1];
		out_main2[2] <= ~out_main[2];

		out_main3 <= out_main2 + 4'b0001;
	end
	else begin								// Setting MSB=0 for Positive Case
		out_main3[3] <= Negative_Flag;
		out_main3[0] <= out_main[0];
		out_main3[1] <= out_main[1];
		out_main3[2] <= out_main[2];
	end
	
	// Set Zero Flag
	if (out_main3 == 4'b0000) begin
		Zero_Flag <= 1;
	end
	else begin
		Zero_Flag <=0;
	end
end

assign out= out_main3;
assign zerof= Zero_Flag;
assign negativef= Negative_Flag;
assign carryf= Carry_Flag;

endmodule
