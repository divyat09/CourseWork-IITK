`timescale 1 ns/10 ps

module eq4_test;

reg [3:0] inp1, inp2;
wire out;

// Call to Module eq2 which is 2 Bit Comparator
eq4 uut (.n1(inp1), .n2(inp2), .res2(out));

initial                         // Test Cases
begin
  inp1 = 4'b0000;
  inp2 = 4'b0001;
  #200;
  $display("Result = %d", out);

  inp1 = 4'b0000;
  inp2 = 4'b0011;
  #200;
  $display("Result = %d", out);
	
  inp1 = 4'b0000;
  inp2 = 4'b0000;
  #200;
  $display("Result = %d", out);
	  
  inp1 = 4'b0011;
  inp2 = 4'b0011;
  #200;
  $display("Result = %d", out);

  inp1 = 4'b1100;
  inp2 = 4'b1000;
  #200;
  $display("Result = %d", out);

  inp1 = 4'b1000;
  inp2 = 4'b1000;
  #200;
  $display("Result = %d", out);
	  
  $stop;
end	

endmodule