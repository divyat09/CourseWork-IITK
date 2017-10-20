`timescale 1 ns/10 ps

module eq2_test;

reg [1:0] inp1, inp2;
wire out;

// Call to eq2 module which is the 2 bit comparator
eq2 uut (.a(inp1), .b(inp2), .res1(out)); 

initial                                 // Test Cases 
begin
  inp1 = 2'b00;
  inp2 = 2'b01;
  #200;
  $display("Result = %d", out);

  inp1 = 2'b00;
  inp2 = 2'b11;
  #200;
  $display("Result = %d", out);
	
  inp1 = 2'b00;
  inp2 = 2'b00;
  #200;
  $display("Result = %d", out);
	  
  inp1 = 2'b11;
  inp2 = 2'b11;
  #200;
  $display("Result = %d", out);

  inp1 = 2'b11;
  inp2 = 2'b10;
  #200;
  $display("Result = %d", out);

  inp1 = 2'b10;
  inp2 = 2'b10;
  #200;
  $display("Result = %d", out);
	  
  $stop;
end	

endmodule