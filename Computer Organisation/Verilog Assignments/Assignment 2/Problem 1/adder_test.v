`timescale 1 ns/10 ps

module adder_test;

reg [3:0] inp1, inp2;
wire[3:0] sum_out;
wire carry_out;

adder uut (.n1(inp1), .n2(inp2), .sum(sum_out), .cout(carry_out));

initial
begin

  inp1 = 4'b0000;
  inp2 = 4'b0001;
  #200;
  $display("Result = %d %d", sum_out, carry_out);

  inp1 = 4'b0000;
  inp2 = 4'b0011;
  #200;
  $display("Result = %d %d", sum_out, carry_out);

  inp1 = 4'b0000;
  inp2 = 4'b0000;
  #200;
  $display("Result = %d %d", sum_out, carry_out);
    
  inp1 = 4'b0011;
  inp2 = 4'b0011;
  #200;
  $display("Result = %d %d", sum_out, carry_out);

  inp1 = 4'b1100;
  inp2 = 4'b1000;
  #200;
  $display("Result = %d %d", sum_out, carry_out);

  inp1 = 4'b1000;
  inp2 = 4'b1000;
  #200;
  $display("Result = %d %d", sum_out, carry_out);

  $stop;
end

endmodule
